//
//  Parser.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

final class Parser<T> where T: Codable {
    
    func parse(from data: Data) -> Result<T> {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            let model = try
                decoder.decode(T.self, from: data)
            return Result.success(payload: model)
        } catch {
            return Result.failure(error: error as NSError)
        }
    }
    
}
