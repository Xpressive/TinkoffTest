//
//  NewsDetailService.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol NewsDetailService {
    func getArticle(news: NewsContent, completion: ((Result<ArticleContent>) -> Void)?)
}
