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
            let itemToSplit = item.title.lowercaseString
            let itemArr = itemToSplit.componentsSeparatedByString(" ")
            if itemArr.contains("tax") || checkForTipAndTax("tax", text: item.title.lowercaseString){
                newEvent!.receipt!.tax = Int64(item.price * 100)
                print(newEvent?.receipt)
            } else if itemArr.contains("tip") || checkForTipAndTax("tip", text: item.title.lowercaseString){
                newEvent!.receipt!.tip = Int64(item.price * 100)
                print(newEvent?.receipt)
            } else {
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("ReceiptItem", inManagedObjectContext: cds.mainQueueContext) as? ReceiptItem
                newItem?.itemDescription = item.title
                newItem?.price = Int64(item.price * 100)
                newItem?.receipt = (newEvent?.receipt)!
                print(newItem)
            }
        }
    }
    
    func addContacts(mates: [Mate]){
        for mate in mates{
            let newContact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: cds.mainQueueContext) as? Contact
            newContact?.firstName = mate.firstName
            newContact?.lastName = mate.lastName
            newContact?.mobileNumber = mate.mobileNumber
            newContact?.uuid = mate.id
            newContact?.event = newEvent
        }
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
        cds.saveChanges()
    }
    
    func fetchAllEvents() -> [Event]{
        let fetchRequest = NSFetchRequest(entityName: "Event")
        do {
            let fetchResults = try cds.mainQueueContext.executeFetchRequest(fetchRequest) as? [Event]
            return (fetchResults!)
        } catch let error as NSError {
            print(error)
        }
        return []
    }
    
    func billIsComplete() {
        // Ready to Save bill to CoreData
        // After stored in Postgres DB -- Send messges to Contacts
    }
    
    
    func userRequestsPayment() {
        // Launch payment controller
    }
    
}