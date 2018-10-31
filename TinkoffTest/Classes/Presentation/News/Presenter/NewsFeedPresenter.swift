//
//  NewsFeedPresenter.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol NewsFeedView: class {
    func updateView()
}

protocol NewsFeedCellView {
    func display(title: String)
    func display(counter: Int)
    func display(date: Date)
}


final class NewsFeedPresenter {
    
    private weak var view: NewsFeedView?
    let router: NewsFeedViewRouter
    private let newsService: NewsService
    
    private var news: [NewsContent] = []
    private var isUpdating = false
    private var hasMoreCache = true
    
    var numberOfNews: Int {
        return news.count
    }
    
    private enum Constants {
        static let limit = 20
    }
    
    init(view: NewsFeedView, router: NewsFeedViewRouter, newsService: NewsService) {
        self.view = view
        self.router = router
        self.newsService = newsService
    }

    
    func viewDidLoad() {
        newsService.obtainCashedNews(limit: Constants.limit, lastDate: nil) { (news) in
            self.news = news
            self.view?.updateView()
        }
        update(limit: Constants.limit, offset: 0)
    }
    
    func configure(cell: NewsFeedTableViewCell, forRow row: Int) {
        let article = news[row]
        cell.display(title: article.title)
        cell.display(date: article.createdTime)
        cell.display(counter: article.counter)
    }
    
    func update(limit: Int, offset: Int) {
        if isUpdating {
            return
        }
        isUpdating = true
        let date = offset == 0 ? nil : news.last?.createdTime
        newsService.obtainNews(limit: limit, offset: offset, lastDate: date) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(payload: let news):
                if offset == 0 {
                    self.news = news
                } else {
                    self.news += news
                }
            case .failure(error: _):
                if !self.hasMoreCache {
                    self.isUpdating = false
                    return
                }
                self.newsService.obtainCashedNews(limit: Constants.limit, lastDate: date, completion: { [weak self] (news) in
                    guard let self = self else { return }
                    if offset == 0 {
                        self.news = news
                    } else {
                        self.news += news
                    }
                    if news.count == 0 {
                        self.hasMoreCache = false
                    }
                })
            }
            self.view?.updateView()
            self.isUpdating = false
        }
    }
    
    func didSelect(cell: NewsFeedTableViewCell, row: Int) {
        news[row].counter += 1
        newsService.increaseViewCounter(article: news[row])
        router.presentDetailsView(for: news[row])
        configure(cell: cell, forRow: row)
    }
    
    func refreshTable() {
        self.hasMoreCache = true
        update(limit: Constants.limit, offset: 0)
    }
    
    func loadMoreNews() {
        update(limit: Constants.limit, offset: news.count)
    }
    
}
