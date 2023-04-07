//
//  CoreDataManager.swift
//  DayCount
//
//  Created by ChangMin on 2023/04/08.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()
        
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
