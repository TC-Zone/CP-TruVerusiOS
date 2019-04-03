//
//  PercistanceService.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/28/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import CoreData

class PercistanceService {
    
    private init() {}
    
    static var context : NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Truverus")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func deleteAllRecords() {
        
        let context = self.context
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("deleted")
        } catch {
            print ("There was an error")
        }
    }
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("context saved!!!!!!!!!!!!!!!!!!!")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
