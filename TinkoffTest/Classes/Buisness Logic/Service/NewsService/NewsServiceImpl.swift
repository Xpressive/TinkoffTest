//
//  NewsServiceImpl.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

final class NewsServiceImpl {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://cfg.tinkoff.ru/news/public/api/platform/v1"
        static let pageSize = "pageSize"
        static let offset = "pageOffset"
        static let slug = "urlSlug"
    }
    
    private enum EndPoint {
        static let news = "/getArticles"
        static let acticle = "/getArticle"
    }
    
    
    // MARK: - Private Properties
    
    private let transport: Transport
    private let newsParser: Parser<NewsSuccessResponse>
    private let articleParser: Parser<ArticleSuccessResponse>
    private let databaseService: DatabaseService
    
    
    // MARK: - Initialization
    
    init(transport: Transport, databaseService: DatabaseService) {
        self.transport = transport
        self.newsParser = Parser<NewsSuccessResponse>()
        self.articleParser = Parser<ArticleSuccessResponse>()
        self.databaseService = databaseService
    }
    
}


// MARK: - NewsServiceImpl

extension NewsServiceImpl: NewsService {
    func obtainCashedNews(limit: Int, lastDate: Date?, completion: (([NewsContent]) -> Void)?) {
        completion?(self.databaseService.getNext(fetchLimit: limit, lastDate: lastDate))
    }
    
    func obtainNews(limit: Int,
                    offset: Int,
                    lastDate: Date?,
                    completion: ((Result<[NewsContent]>) -> Void)?) {
        
        let url = Constants.baseURL + EndPoint.news
        self.transport.request(method: .get,
                               url: url,
                               query: [Constants.pageSize: "\(limit)",Constants.offset: "\(offset)"])
        { (response) in
            
            switch response {
            case .success(let payload):
                let resultBody = payload.resultBody
                let parseResult = self.newsParser.parse(from: resultBody)
                switch parseResult {
                case .success(let model):
                    self.databaseService.saveOrUpdate(newsModels: model.response.news) {
                        completion?(Result.success(payload: self.databaseService.getNext(fetchLimit: limit, lastDate: lastDate)))
                    }
                case .failure(let error):
                    completion?(Result.failure(error: error as NSError))
                }
            case .failure(let error):
                completion?(Result.failure(error: error as NSError))
            }
            
        }
    }
    
    func increaseViewCounter(article: NewsContent) {
        self.databaseService.saveOrUpdate(newsModels: [article])
    }
}


// MARK: - NewsDetailService Impl

extension NewsServiceImpl: NewsDetailService {
    
    func getArticle(news: NewsContent, completion: ((Result<ArticleContent>) -> Void)?) {
        let url = Constants.baseURL + EndPoint.acticle
        
        // Если уже есть в кэше, отдаем его
        if let content = self.databaseService.findNewsContent(id: news.id) {
            completion?(Result.success(payload: ArticleContent(text: content)))
            return
        }
        
        transport.request(method: .get, url: url, query: [Constants.slug: news.slug]) { (response) in
            switch response {
            case .success(payload: let payload):
                let resultBody = payload.resultBody
                let parseResult = self.articleParser.parse(from: resultBody)
                switch parseResult {
                case .success(let model):
                    var updatedNews = news
                    updatedNews.content = model.response.text
                    self.databaseService.saveOrUpdate(newsModels: [updatedNews])
                    completion?(Result.success(payload: model.response))
                case .failure(let error):
                    completion?(Result.failure(error: error as NSError))
                }
            case .failure(error: let error):
                completion?(Result.failure(error: error as NSError))
            }
        }
    }
}
