//
//  PaymentsController.swift
//  CheckMates
//
//  Created by Gregory Berns-Leone on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation

class Contact {
    let phoneNumber : Int? = nil
}

class PaymentsController : NSObject {
    
    let apiManager = DwollaAPIManager.sharedInstance
    
    func startRequestFrom(contact: Contact, amount: Int, note: String) {
        if apiManager.hasOAuthToken() {
            self.finishRequestFrom(contact, amount: amount, note: note, token: apiManager.OAuthToken!)
        } else if apiManager.hasRefreshToken() {
            apiManager.refreshTokenAndCallBack(finishRequestFrom)
        }
        
    }
    
    func finishRequestFrom(contact: Contact, amount: Int, note: String, token: String) {
        
    }
    
}