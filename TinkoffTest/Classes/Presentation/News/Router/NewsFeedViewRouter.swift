//
//  NewsFeedRouter.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import UIKit

protocol NewsFeedViewRouter: ViewRouter {
    func presentDetailsView(for article: NewsContent)
}

final class NewsFeedViewRouterImpl: NewsFeedViewRouter {
    
    private weak var newsFeedTableViewController: NewsFeedTableViewController?
    private var article: NewsContent!
    
    init(newsFeedTableViewController: NewsFeedTableViewController) {
        self.newsFeedTableViewController = newsFeedTableViewController
    }
    
    func presentDetailsView(for article: NewsContent) {
        self.article = article
        newsFeedTableViewController?.performSegue(withIdentifier: "NewsFeedSceneToNewsDetailsSceneSegue", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newsDetailViewController = segue.destination as? NewsDetailViewController {
            newsDetailViewController.configurator = NewsDetailConfiguratorImpl(article: article)
        }
    }
    
}
