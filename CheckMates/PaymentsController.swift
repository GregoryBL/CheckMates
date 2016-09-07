//
//  PaymentsController.swift
//  CheckMates
//
//  Created by Gregory Berns-Leone on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import SwiftyJSON

//class Contact {
//    var phoneNumber : Int = 0
//}

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
    
}