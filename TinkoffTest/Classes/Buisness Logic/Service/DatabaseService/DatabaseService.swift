//
//  DatabaseService.swift
//  TinkoffTest
//
//  Created by Alexey Kuznetsov on 30.10.2018.
//  Copyright © 2018 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import CoreData

final class DatabaseService {
    
    
    // MARK: - Private Properties
    
    private let persistendContainer: NSPersistentContainer
    
    
    // MARK: - Init
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        persistendContainer = appDelegate.persistentContainer
    }
    
    // MARK: - Public Methods
    
    func saveOrUpdate(newsModels: [NewsContent], completion: (() -> ())? = nil) {
        persistendContainer.performBackgroundTask { (context) in
            defer {
                completion?()
            }
            for model in newsModels {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewsMO")
                fetchRequest.predicate = NSPredicate(format: "id = %@", model.id as CVarArg)
                do {
                    var news = try context.fetch(fetchRequest).first
                    if news == nil {
                        let entity = NSEntityDescription.entity(forEntityName: "NewsMO",
                                                                in: context)!
                        news = NSManagedObject(entity: entity, insertInto: context)
                    }
                    news?.setValue(model.id, forKey: "id")
                    news?.setValue(model.createdTime, forKey: "createdTime")
                    news?.setValue(model.title, forKey: "title")
                    news?.setValue(model.slug, forKey: "slug")
                    
                    if let cont = model.content {
                        news?.setValue(cont, forKey: "content")
                    }
                    if model.counter != 0 {
                        news?.setValue(model.counter, forKey: "counter")
                    }
                } catch let error {
                    print("Could not save. \(error)")
                }
            }
            do {
                try context.save()
            } catch let error {
                print("Could not save. \(error)")
            }
        }
    }
    
    func findNewsContent(id: String) -> String? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewsMO")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        do {
            guard let news = try persistendContainer.viewContext.fetch(fetchRequest).first else { return nil }
            return news.value(forKey: "content") as? String
        }
        catch let error {
            print("Could not find. \(error)")
            return nil
        }
    }
    
    
    func getNext(fetchLimit: Int, lastDate: Date?) -> [NewsContent] {
        return getNext(fetchLimit: fetchLimit, lastDate: lastDate).map({ managedObject in
            return self.createNewsContentFrom(news: managedObject)
        })
    }
    
    
    // MARK: - Private Methods
    
    private func getNext(fetchLimit: Int, lastDate: Date?) -> [NSManagedObject] {
        var news = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewsMO")
        fetchRequest.fetchLimit = fetchLimit
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false)]
        if let date = lastDate {
            fetchRequest.predicate = NSPredicate(format: "createdTime < %@", date as CVarArg)
        }
        do {
            news = try persistendContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Could not save. \(error)")
        }
        return news
    }
    
    private func createNewsContentFrom(news: NSManagedObject) -> NewsContent {
        return NewsContent(id: news.value(forKey: "id") as! String,
                    title: news.value(forKey: "title") as! String,
                    createdTime: news.value(forKey: "createdTime") as! Date,
                    slug: news.value(forKey: "slug") as! String,
                    content: news.value(forKey: "content") as? String,
                    counter: news.value(forKey: "counter") as! Int)
    }
    
}

