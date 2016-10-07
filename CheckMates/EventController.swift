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
    var event : Event
    
    init(with existingEvent: Event?) {
        if let existingEvent = existingEvent {
            event = existingEvent
        } else {
            event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: cds.mainQueueContext) as! Event
            let newReceipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: cds.mainQueueContext) as! Receipt
            newReceipt.event = event
            event.createdAt = Date().timeIntervalSinceReferenceDate
        }
    }
    
    func addReceiptItem(_ description: String, price: Int64) {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ReceiptItem", into: cds.mainQueueContext) as? ReceiptItem
        newItem?.itemDescription = description
        newItem?.price = price
        newItem?.receipt = event.receipt!
    }
    
    func deleteReceiptItem(_ receiptItem: ReceiptItem) {
        cds.mainQueueContext.delete(receiptItem)
    }
    
    func addLines(_ lines: [String]) {
//        if event.receipt == nil {
//            let newReceipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: cds.mainQueueContext) as! Receipt
//            print("made new receipt")
//            newReceipt.event = event
//        }
        for line in lines {
            let items = findGoodLines(line)
            for (description, price) in items {
                let split = description.lowercased()
                let itemArr = split.components(separatedBy: " ")
                if itemArr.contains("tax") || checkForTipAndTax("tax", text: description){
                    event.receipt!.tax = price
                } else if itemArr.contains("tip") || checkForTipAndTax("tip", text: description){
                    event.receipt!.tip = Int64(price)
                } else {
                    addReceiptItem(description, price: price)
                }
            }
        }
    }
        
    fileprivate func findGoodLines(_ line: String) -> [(String, Int64)] {
        let digits = CharacterSet.decimalDigits
        var price: Float = 0
        var goodLines: [(String, Int64)] = []
        
        // trim white leading and trailing white space
        let components = line.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        let lineAsString = components.joined(separator: " ")
        let lineAsArray = lineAsString.components(separatedBy: " ")
        
        // add item as long as it is not a blank line
        guard lineAsString != "" && lineAsString.range(of: "Suite") == nil else { print("discarding line"); return [] }
        
        if((lineAsString.rangeOfCharacter(from: digits)) != nil) {
            
            // determine the price assigned to that line
            let lastDigits = lineAsArray.last!.trimmingCharacters(in: CharacterSet.init(charactersIn: "$"))
            if(lastDigits.asFloat < 999) {
                price = lastDigits.asFloat
                
                // if the first item in the array is not a number, there is probably only one of them
                if((lineAsArray[0].rangeOfCharacter(from: digits)) != nil) {
                    
                    // either the firstValue represents the quantity or an address
                    let components = lineAsArray[0].components(separatedBy: CharacterSet.decimalDigits.inverted)
                    let firstNumber = components.joined(separator: "").asInteger
                    if(firstNumber < 10) {
                        // the first number is probably the item count, so create the appropriate number of items
                        var i = 1
                        while i <= firstNumber {
                            goodLines.append((lineAsString, Int64(price * 100)))
                            i += 1
                        }
                    }
                }
                else {
                    goodLines.append((lineAsString, Int64(price * 100)))
                }
            }
        }
        return goodLines
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
    
    static func fetchAllEvents() -> [Event] {
        let fetchRequest : NSFetchRequest<Event> = NSFetchRequest(entityName: "Event")
        do {
            let fetchResults = try (UIApplication.shared.delegate as! AppDelegate).coreDataStack.mainQueueContext.fetch(fetchRequest)
            return (fetchResults)
        } catch let error as NSError {
            print(error)
        }
        return []
    }
    
    func billIsComplete() {
//        print(self.newEvent!.receipt!)
//        if self.event.receipt == nil {
//            let newReceipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: cds.mainQueueContext) as? Receipt
////            print(newReceipt)
//            newReceipt!.event = event
////            print(newReceipt)
////            print(event)
////            print(event.receipt)
////            saveEvent()
////            print("saved event")
//        }
        self.saveEvent()
        let serverController = ServerController()
 
        serverController.sendNewReceiptToServer(event.receipt!, sender: self) // pass in self to get sendMessages called when it completes
    }
    
    func sendMessages() {
        print("starting to send messages")
        let mc = MessageController()
        let backEndID = event.receipt!.backEndID!
//        print(backEndID)
        let contacts = event.contacts!.allObjects as! [Contact]
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
                    event.receipt!.backEndID = String(id)
                    saveEvent()
                }
//                print(bill)
            }
//            print(self.newEvent!.receipt!.backEndID)
//            print("finish parsing original response")
        }
    }
    
    fileprivate func userIDHasMatch(_ userID: String) -> Contact? {
        let contacts = event.contacts?.allObjects as! [Contact]
        for contact in contacts {
            if contact.uuid == userID {
                return contact
            }
        }
        return nil
    }
    
    fileprivate func receiptItemHasMatch(_ itemDescription : String) -> ReceiptItem? {
        let receiptItems = event.receipt?.items!.allObjects as! [ReceiptItem]
        for receiptItem in receiptItems{
            if receiptItem.itemDescription == itemDescription {
                return receiptItem
            }
        }
        return nil
    }
    
    func userDidRequestPayment() {
        let pc = PaymentsController()
        pc.createRequestsForEvent(event)
    }
}
