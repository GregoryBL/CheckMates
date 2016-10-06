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
    
    let cds = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    var event : Event?
    
    func createNewEvent(){
        event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: cds.mainQueueContext) as? Event
        let date = Date()
        event!.createdAt = date.timeIntervalSinceReferenceDate
    }
    
    func addBillItems(_ items: ItemStore){
        if event == nil {
            createNewEvent()
        }
        if event?.receipt == nil {
            event!.receipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: cds.mainQueueContext) as? Receipt
        }
        for item in items.allItems{
            let itemToSplit = item.title.lowercased()
            let itemArr = itemToSplit.components(separatedBy: " ")
            if itemArr.contains("tax") || checkForTipAndTax("tax", text: item.title.lowercased()){
                event!.receipt!.tax = Int64(item.price * 100)
//                print(newEvent?.receipt)
            } else if itemArr.contains("tip") || checkForTipAndTax("tip", text: item.title.lowercased()){
                event!.receipt!.tip = Int64(item.price * 100)
//                print(newEvent?.receipt)
            } else {
                let newItem = NSEntityDescription.insertNewObject(forEntityName: "ReceiptItem", into: cds.mainQueueContext) as? ReceiptItem
                newItem?.itemDescription = item.title
                newItem?.price = Int64(item.price * 100)
                newItem?.receipt = (event?.receipt)!
//                print(newItem)
            }
        }
    }
    
    func addContacts(_ mates: [Mate]){
        for mate in mates{
            let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: cds.mainQueueContext) as? Contact
            newContact?.firstName = mate.firstName
            newContact?.lastName = mate.lastName
            newContact?.mobileNumber = mate.mobileNumber
            newContact?.uuid = mate.id
            newContact?.event = event
        }
    }
    
    fileprivate func checkForTipAndTax(_ regex: String, text: String) -> Bool {
        var results : [NSTextCheckingResult] = []
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            results = regex.matches(in: text,
                                            options: [], range: NSMakeRange(0, nsString.length))
//            print(results)
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            
        }
        
        return results.count > 0
    }
    
    
    func saveEvent(){
        cds.saveChanges()
    }
    
    func fetchAllEvents() -> [Event] {
        let fetchRequest : NSFetchRequest<Event> = NSFetchRequest(entityName: "Event")
        do {
            let fetchResults = try cds.mainQueueContext.fetch(fetchRequest)
            return (fetchResults)
        } catch let error as NSError {
            print(error)
        }
        return []
    }
    
    func billIsComplete() {
//        print(self.newEvent!.receipt!)
        self.saveEvent()
        let serverController = ServerController()
        serverController.sendNewReceiptToServer((self.event!.receipt!), sender: self) // pass in self to get sendMessages called when it completes
    }
    
    func sendMessages() {
        print("starting to send messages")
        let mc = MessageController()
        let backEndID = event!.receipt!.backEndID!
//        print(backEndID)
        let contacts = event!.contacts!.allObjects as! [Contact]
//        print(contacts)
        mc.textContacts(contacts, billId: backEndID)
    }
    
    func parseJSON(_ data: Data){

        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dictionary = json as? [String: Any] {
            
            if let itemArray = dictionary["items"] as? [Any] {
//                print(itemArray)
                for thing in itemArray {
                    if let item = thing as? [String: Any] {
                        if let contactName = item["user_id"] as? String, let itemString = item["item_description"] as? String {
//                            print(contactName)
                            let contact = userIDHasMatch(contactName)
                            if let item = receiptItemHasMatch(itemString) {
                                item.contact = contact
//                                print(item)
//                                print(item.contact)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func parseOriginalResponse(_ data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
//        print(json)
        
        if let dictionary = (json as? [String: Any]) {
//            print("dictionary: \(dictionary)")
            if let bill = dictionary["bill"] as? [String: Any] {
//                print("bill: \(bill)")
                if let id = (bill["id"] as? Int) {
//                    print("id: \(id)")
                    event?.receipt!.backEndID = String(id)
                    saveEvent()
                }
//                print(bill)
            }
//            print(self.newEvent!.receipt!.backEndID)
//            print("finish parsing original response")
        }
    }
    
    fileprivate func userIDHasMatch(_ userID: String) -> Contact? {
        let contacts = event?.contacts?.allObjects as! [Contact]
        for contact in contacts {
            if contact.uuid == userID {
                return contact
            }
        }
        return nil
    }
    
    fileprivate func receiptItemHasMatch(_ itemDescription : String) -> ReceiptItem? {
        let receiptItems = event?.receipt?.items!.allObjects as! [ReceiptItem]
        for receiptItem in receiptItems{
            if receiptItem.itemDescription == itemDescription {
                return receiptItem
            }
        }
        return nil
    }
    
    func userDidRequestPayment() {
        let pc = PaymentsController()
        pc.createRequestsForEvent(event!)
    }
}
