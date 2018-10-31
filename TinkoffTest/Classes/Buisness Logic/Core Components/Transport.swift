//
//  Transport.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

/// Результат запроса транспорта
struct ResponseResult {
    let httpStatusCode: Int
    let resultBody: Data
}

enum HTTPTransportMethod: String {
    case get     = "GET"
    case post    = "POST"
}

///Transport
final class Transport {
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession(configuration: .default)
    
    // MARK: - Initialization
    
    init() {}
    
    func request(method: HTTPTransportMethod,
                 url: String,
                 query: [String: String],
                 completion: @escaping ((Result<ResponseResult>) -> Void)) {
        var queryParams = "?"
        for (item, value) in query {
            queryParams += "\(item)=\(value)&"
        }
        queryParams = String(queryParams.dropLast())
        var request = URLRequest(url: URL(string: url + queryParams)!)
        request.httpMethod = method.rawValue
        urlSession.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(Result.failure(error: error! as NSError))
                return
            }
            guard let resultData = data else {
                completion(Result.failure(error: NSError()))
                return
            }
            
            self.debugPrint(data: resultData)
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(Result.failure(error: NSError()))
                return
            }
            let payload = ResponseResult(httpStatusCode: httpResponse.statusCode,
                                        resultBody: resultData)
            completion(Result.success(payload: payload))
            
        }.resume()
    }
}

// MARK: - Debug Print

private extension Transport {
    
    func debugPrint(data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        print(json ?? "<null>")
    }
}



