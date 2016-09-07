//
//  EventController.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/6/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import CoreData

class EventController: UIViewController {

    let cds = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    var contacts : [Mate]? = []
    var itemStore : ItemStore?
    
    func saveEvent(){
        
        let newEvent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: cds.mainQueueContext) as! Event
        
        let date = NSDate()
        newEvent.createdAt = date.timeIntervalSinceReferenceDate
        
        let newReceipt = NSEntityDescription.insertNewObjectForEntityForName("Receipt", inManagedObjectContext: cds.mainQueueContext) as! Receipt
        
        newReceipt.tax = 932
        newReceipt.tip = 1880
        newReceipt.event = newEvent
        
        let salad = NSEntityDescription.insertNewObjectForEntityForName("ReceiptItem", inManagedObjectContext: cds.mainQueueContext) as! ReceiptItem
        salad.price = 1299
        salad.itemDescription = "Salad with green beans and tomatoes"
        salad.receipt = newReceipt
        
        let bjork = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: cds.mainQueueContext) as! Contact
        bjork.firstName = "bjork"
        bjork.id = "8rw8w4890w089"
        bjork.mobileNumber = "7892225551"
        bjork.event = newEvent
        cds.saveChanges()
    }
    
    func receivedData(){
        let fetchRequest = NSFetchRequest(entityName: "Event")
        do {
            let fetchResults = try cds.mainQueueContext.executeFetchRequest(fetchRequest) as? [Event]
            print(fetchResults![0].contacts.allObjects[0])
        } catch let error as NSError {
            print(error)
        }
    }
    
}