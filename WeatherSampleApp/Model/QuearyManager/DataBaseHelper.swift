//
//  QueryManager.swift
//  SampleTask
//
//  Created by sunilreddy on 25/05/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import Foundation
import CoreData
class DatabaseController {
    
    private init(){}
    
    // MARK: Class Function
    
    class func getContext() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    class func deleteAll(_ entity: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try self.getContext().execute(request)
        } catch {
            print(error)
        }
    }
    
    class func totalCount(_ entity: String) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var totalCount: Int = 0
        
        do {
            let searchResults = try self.getContext().fetch(fetchRequest)
            totalCount = searchResults.count
        }
        catch {
            print("Error: \(error)")
        }
        return totalCount
    }
    
    class func getSingleData(_ entity: String, _ predicate: NSPredicate?) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        var result:NSManagedObject? = nil
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            if (searchResults.count > 0) {
                result = searchResults[0] as? NSManagedObject
            }
        }
        catch {
            print("Error: \(error)")
        }
        return result!
    }
    
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WeatherSampleApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    class func getEntity<T>(context: NSManagedObjectContext) -> T where T: NSManagedObject {
        if #available(iOS 10, *) {
            
            let obj = T(context: context)
            return obj
        } else {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: NSStringFromClass(T.self), in: context) else {
                fatalError("Core Data entity name doesn't match.")
            }
            let obj = T(entity: entityDescription, insertInto: context)
            return obj
        }
    }
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
