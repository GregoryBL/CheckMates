//
//  PaymentsController.swift
//  CheckMates
//
//  Created by Gregory Berns-Leone on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import SwiftyJSON


class PaymentsController : NSObject {
    
    let apiManager = DwollaAPIManager.sharedInstance
    
    func startRequestFrom(contact: Contact, amount: Int, notes: String) {
        if apiManager.hasOAuthToken() {
            let requestWithToken = finishRequestFrom(contact, amount: amount, notes: notes)
            print(requestWithToken)
            requestWithToken(apiManager.OAuthToken!)
        } else if apiManager.hasRefreshToken() {
            let callback = finishRequestFrom(contact, amount: amount, notes: notes)
            print(callback)
            apiManager.refreshTokenAndCallBack(callback)
        }
        print("startRequest ending")
    }
    
    func finishRequestFrom(contact: Contact, amount: Int, notes: String) -> (String -> Void) {
        print("called finishRequest")
        return { token in
            let request = DwollaRequest.init(sourceID: String(contact.mobileNumber), sourceType: "Phone", amount: amount, notes: notes, token: token)
            let afRequest = request.requestPayment()
            afRequest.response { request, response, data, error in
                print(request?.allHTTPHeaderFields)
                print(JSON(data: data!))
            }
            print("payment requested")
        }
    }
    
    func createRequestsForEvent(event: Event) {
        let billItems = event.receipt!.items!.allObjects as! [ReceiptItem]
        
        var billTotal = 0
        for item in billItems {
            billTotal = billTotal + Int(item.price)
        }
        let tax = event.receipt!.tax
        let tip = event.receipt!.tip
        
        let taxAndTip = tax + tip
        
        let contacts = event.contacts?.allObjects as! [Contact]
        
        var unpaidPortion = billTotal
        var unpaidTaxAndTip = taxAndTip
        
        let unansweredContacts : NSMutableArray = []
        
        for contact in contacts {
            let contactItems = contact.items!
            if contactItems.count == 0 {
                unansweredContacts.addObject(contact)
            } else {
                var contactSubtotal = 0
                for item in contactItems {
                    contactSubtotal = contactSubtotal + Int(item.price)
                }
                let contactTaxAndTip = (contactSubtotal / billTotal) * Int(taxAndTip)
                let contactTotal = contactSubtotal + contactTaxAndTip
                unpaidPortion = unpaidPortion - contactSubtotal
                unpaidTaxAndTip = unpaidTaxAndTip - contactTaxAndTip
                startRequestFrom(contact, amount: contactTotal, notes: "CheckMates Payment Request")
            }
        }
        
        // Now the unanswered ones
        
        let numUnanswered = unansweredContacts.count
        let unansweredContactsTotal = Int(unpaidPortion + unpaidTaxAndTip) / numUnanswered // self
        
        for contact in unansweredContacts {
            startRequestFrom(contact as! Contact, amount: unansweredContactsTotal, notes: "CheckMates Payment Request")
        }
    }
}