//
//  NewsResponse.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

struct NewsSuccessResponse: Codable {
    
    let response: NewsResponse
    
}

struct NewsResponse: Codable {
    
    let news: [NewsContent]
    
}
