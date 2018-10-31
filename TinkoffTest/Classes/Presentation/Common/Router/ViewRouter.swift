//
//  ViewRouter.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import UIKit

protocol ViewRouter {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

extension ViewRouter {
    func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
}
