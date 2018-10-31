//
//  News.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

struct NewsContent: Codable {
    
    let id: String
    let title: String
    let createdTime: Date
    let slug: String
    
    // Не указан в CodingKeys, так как в ответе от сервера по условию text мы игнорируем
    var content: String?
    var counter = 0
    
    private enum CodingKeys: String, CodingKey {
        case id, title, createdTime, slug
    }
}
