//
//  Result.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(payload: T)
    case failure(error: Error)
}

