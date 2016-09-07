//
//  CoreDataStack.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/6/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    let managedObjectModelName: String
    
    required init(modelName: String){
        managedObjectModelName = modelName
    }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL =
            NSBundle.mainBundle().URLForResource(self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var coordinator =
            NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(pathComponent)
        
        let store = try! coordinator.addPersistentStoreWithType(NSSQLiteStoreType,
                                                                configuration: nil,
                                                                URL: url,
                                                                options: nil)
        return coordinator
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        
        return moc
    }()
    
    func saveChanges(){
        do{
            try self.mainQueueContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
}