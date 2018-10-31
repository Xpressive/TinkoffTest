//
//  NewsDetailViewController.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import UIKit

final class NewsDetailViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    
    var presenter: NewsDetailPresenter!
    var configurator: NewsDetailConfigurator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(newsDetailViewController: self)
        presenter.viewDidLoad()
    }
    
}


extension NewsDetailViewController: NewsDetailView {
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func updateView(with article: NewsContent) {
        DispatchQueue.main.async {
            self.titleLabel.text = article.title
            let dateForm = DateFormatter()
            dateForm.dateStyle = .long
            self.dateLabel.text = dateForm.string(from: article.createdTime)
            if let cont = article.content {
                self.contentLabel.attributedText = cont.html2Attributed
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    
}
