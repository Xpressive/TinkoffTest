//
//  NewsDetailConfigurator.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol NewsDetailConfigurator {
    func configure(newsDetailViewController: NewsDetailViewController)
}

final class NewsDetailConfiguratorImpl: NewsDetailConfigurator {
    
    let article: NewsContent
    
    init(article: NewsContent) {
        self.article = article
    }
    
    func configure(newsDetailViewController: NewsDetailViewController) {
        
        let newsService = NewsServiceImpl(transport: Transport(), databaseService: DatabaseService())
        
        let presenter = NewsDetailPresenter(view: newsDetailViewController,
                                            newsDetailService: newsService,
                                            article: article)
        
        newsDetailViewController.presenter = presenter
    }
    
}
