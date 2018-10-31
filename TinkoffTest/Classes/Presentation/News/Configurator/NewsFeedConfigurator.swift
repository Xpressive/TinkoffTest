//
//  NewsFeedConfigurator.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol NewsFeedConfigurator {
    func configure(newsFeedTableViewController: NewsFeedTableViewController)
}

final class NewsFeedConfiguratorImpl: NewsFeedConfigurator {
    
    func configure(newsFeedTableViewController: NewsFeedTableViewController) {

        let router = NewsFeedViewRouterImpl(newsFeedTableViewController: newsFeedTableViewController)

        let newsService = NewsServiceImpl(transport: Transport(), databaseService: DatabaseService())
        
        
        let presenter = NewsFeedPresenter(view: newsFeedTableViewController,
                                          router: router,
                                          newsService: newsService)
        
        newsFeedTableViewController.presenter = presenter
    }
}
