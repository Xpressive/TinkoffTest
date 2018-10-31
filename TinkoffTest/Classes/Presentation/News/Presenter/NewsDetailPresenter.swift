//
//  NewsDetailPresenter.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol NewsDetailView: class {
    func updateView(with article: NewsContent)
    func startAnimating()
}

final class NewsDetailPresenter {
    
    private weak var view: NewsDetailView?
    private let newsDetailService: NewsDetailService
    
    private var article: NewsContent
    
    init(view: NewsDetailView, newsDetailService: NewsDetailService, article: NewsContent) {
        self.view = view
        self.article = article
        self.newsDetailService = newsDetailService
    }
    
    func viewDidLoad() {
        self.view?.startAnimating()
        newsDetailService.getArticle(news: article) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(payload: let article):
                self.article.content = article.text
                self.view?.updateView(with: self.article)
            case .failure(error: _):
                // TODO: - Обработка ошибки
                break
            }
        }
    }
    
}
