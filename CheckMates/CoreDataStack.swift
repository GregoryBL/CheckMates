//
//  CoreDataStack.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    let managedObjectModelName: String
    
    required init(modelName: String){
        managedObjectModelName = modelName
    }
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL =
            Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    fileprivate var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }()
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var coordinator =
            NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(pathComponent)
        
        let store = try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                configurationName: nil,
                                                                at: url,
                                                                options: nil)
        return coordinator
    }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        
        return moc
    }()
    
    func saveChanges(){
        do{
            try self.mainQueueContext.save()
        } catch let error as NSError {
            print("Saving error:")
            print(error)
        }
    }
}
