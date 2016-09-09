//
//  EventController.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class EventController {
    
    let cds = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    var newEvent : Event?
    
    func createNewEvent(){
        newEvent = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: cds.mainQueueContext) as? Event
        let date = NSDate()
        newEvent!.createdAt = date.timeIntervalSinceReferenceDate
        
    }
    
    func addBillItems(items: ItemStore){
        if newEvent != nil && newEvent?.receipt == nil {
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
        print(self.newEvent)
        self.saveEvent()
        let serverController = ServerController()
        serverController.sendNewReceiptToServer((self.newEvent?.receipt!)!, sender: self) // pass in self to get sendMessages called when it completes
    }
    
    func sendMessages() {
        print("starting to send messages")
        let mc = MessageController()
        print(self.newEvent?.receipt?.backEndID)
        mc.textContacts(self.newEvent!.contacts?.allObjects as! [Contact], billId: (self.newEvent?.receipt?.backEndID)!)
    }
    
    func parseJSON(data: NSData){

        let json = JSON(data: data)
        
        let items = json["items"]
        print(items)
        
        if let itemArray = (json["items"].array) {
            print(itemArray)
            for item in itemArray {
                if let contact = userIDHasMatch(item["user_id"].string?) {
                    if let item = receiptItemHasMatch(item["item_description"].string!) {
                        item.contact = contact
                        print(item)
                        print(item.contact)
                    }
                }
            }
        }
    }
    
    func parseOriginalResponse(data: NSData) {
        let json = JSON(data: data)
        print(json)
        if json["bill"] != nil {
            print(json["bill"])
            print(json["bill"]["id"])
            print(json["bill"]["id"].string)
            print(json["bill"]["id"].int)
            let id = (String(json["bill"]["id"].int!))
            print(id)
            newEvent?.receipt!.backEndID = id
        }
        print(self.newEvent?.receipt?.backEndID!)
        print("finish parsing original response")
    }
    
    private func userIDHasMatch(userID: String) -> Contact? {
        let contacts = newEvent?.contacts?.allObjects as! [Contact]
        for contact in contacts {
            if contact.uuid == userID {
                return contact
            }
        }
        return nil
    }
    
    private func receiptItemHasMatch(itemDescription : String) -> ReceiptItem? {
        let receiptItems = newEvent?.receipt?.items!.allObjects as! [ReceiptItem]
        for receiptItem in receiptItems{
            if receiptItem.itemDescription == itemDescription {
                return receiptItem
            }
        }
        return nil
    }
    
    func userDidRequestPayment() {
        let pc = PaymentsController()
        pc.createRequestsForEvent(self.newEvent!)
    }
}