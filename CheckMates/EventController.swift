//
//  EventController.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import CoreData

class EventController {
    
    let cds = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    var newEvent : Event?
    
    func createNewEvent(){
        newEvent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: cds.mainQueueContext) as? Event
        let date = NSDate()
        newEvent!.createdAt = date.timeIntervalSinceReferenceDate
        
    }
    
    func addBillItems(items: ItemStore){
        if newEvent != nil &&  newEvent?.receipt == nil {
            newEvent!.receipt = NSEntityDescription.insertNewObjectForEntityForName("Receipt", inManagedObjectContext: cds.mainQueueContext) as? Receipt
        }
        for item in items.allItems{
            let itemToSplit = item
            let itemArr = itemToSplit.title.componentsSeparatedByString(" ")
            if itemArr.contains("tax") || checkForTipAndTax("tax", text: item.title){
                newEvent!.receipt!.tax = Int64(item.price)
            } else if itemArr.contains("tip") || checkForTipAndTax("tip", text: item.title){
                newEvent!.receipt!.tip = Int64(item.price)
            } else {
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("ReceiptItem", inManagedObjectContext: cds.mainQueueContext) as? ReceiptItem
                newItem?.itemDescription = item.title
                newItem?.price = Int64(item.price)
                newItem?.receipt = (newEvent?.receipt)!
            }
        }
    }
    
    func addContacts(){
        
    }
    
    private func checkForTipAndTax(regex: String, text: String) -> Bool {
        var results = []
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            results = regex.matchesInString(text,
                                            options: [], range: NSMakeRange(0, nsString.length))
            print(results)
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            
        }
        
        return results.count > 0
    }
    
    
    func saveEvent(){
        
//        let newEvent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: cds.mainQueueContext) as! Event
//        
//        let date = NSDate()
//        newEvent.createdAt = date.timeIntervalSinceReferenceDate
//        
//        let newReceipt = NSEntityDescription.insertNewObjectForEntityForName("Receipt", inManagedObjectContext: cds.mainQueueContext) as! Receipt
//        
//        newReceipt.tax = 932
//        newReceipt.tip = 1880
//        newReceipt.event = newEvent
//        
//        let salad = NSEntityDescription.insertNewObjectForEntityForName("ReceiptItem", inManagedObjectContext: cds.mainQueueContext) as! ReceiptItem
//        salad.price = 1299
//        salad.itemDescription = "Salad with green beans and tomatoes"
//        salad.receipt = newReceipt
//        
//        let bjork = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: cds.mainQueueContext) as! Contact
//        bjork.firstName = "bjork"
//        bjork.uuid = "8rw8w4890w089"
//        bjork.mobileNumber = "7892225551"
//        bjork.event = newEvent
        cds.saveChanges()
    }
    
    func receivedData(){
        let fetchRequest = NSFetchRequest(entityName: "Event")
        do {
            let fetchResults = try cds.mainQueueContext.executeFetchRequest(fetchRequest) as? [Event]
            print(fetchResults![0].contacts!.allObjects[0])
        } catch let error as NSError {
            print(error)
        }
    }
}