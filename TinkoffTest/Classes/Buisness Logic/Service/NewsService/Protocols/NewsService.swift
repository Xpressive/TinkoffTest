//
//  NewsService.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

protocol NewsService {
    func obtainCashedNews(limit: Int, lastDate: Date?, completion: (([NewsContent]) -> Void)?)
    func obtainNews(limit: Int, offset: Int, lastDate: Date?, completion: ((Result<[NewsContent]>) -> Void)?)
    func increaseViewCounter(article: NewsContent)
}
