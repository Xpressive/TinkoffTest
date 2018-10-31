//
//  NewsMO+CoreDataProperties.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsMO> {
        return NSFetchRequest<NewsMO>(entityName: "NewsMO")
    }

    @NSManaged public var id: String
    @NSManaged public var createdTime: NSDate
    @NSManaged public var title: String
    @NSManaged public var slug: String
    @NSManaged public var content: String?
    @NSManaged public var counter: Int

}
