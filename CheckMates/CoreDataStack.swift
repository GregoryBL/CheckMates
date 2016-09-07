//
//  CoreDataStack.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/6/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import CoreData

//lazy var applicationDocumentsDirectory: NSURL = {
//    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//    return urls[urls.count-1]
//}()
//
//lazy var managedObjectModel: NSManagedObjectModel = {
//    let modelURL = NSBundle.mainBundle().URLForResource("CheckMates", withExtension: "momd")!
//    return NSManagedObjectModel(contentsOfURL: modelURL)!
//}()
//
//lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
//    var failureReason = "There was an error creating or loading the application's saved data."
//    do {
//        try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
//    } catch {
//        var dict = [String: AnyObject]()
//        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason
//        
//        dict[NSUnderlyingErrorKey] = error as NSError
//        let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//         NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
//        abort()
//    }
//    
//    return coordinator
//}()
//
//lazy var managedObjectContext: NSManagedObjectContext = {
//    let coordinator = self.persistentStoreCoordinator
//    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//    managedObjectContext.persistentStoreCoordinator = coordinator
//    return managedObjectContext
//}()
//
//func saveContext () {
//    if managedObjectContext.hasChanges {
//        do {
//            try managedObjectContext.save()
//        } catch {
//            let nserror = error as NSError
//            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//            abort()
//        }
//    }
//}