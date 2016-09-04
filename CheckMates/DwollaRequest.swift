//
//  DwollaRequest.swift
//  checkMates
//
//  Created by Gregory Berns-Leone on 9/3/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import Alamofire

class DwollaRequest {
    
    static let requestURL = "https://uat.dwolla.com/oauth/rest/requests/"
    
    var headers : [String: String]
    
    init(sourceID: String, sourceType: String, amount: Int, notes: String, token: String) {
        self.sourceID = sourceID // ID of user to request funds from. Probably a phone number or email address
        self.sourceType = sourceType // "Dwolla", "Email", or "Phone"
        self.amount = amount
        self.notes = notes
        
        self.headers = [
            "Content-Type": "application/json",
            "Accept": "application/vnd.dwolla.v1.hal+json",
            "Authorization": "Bearer" + token
        ]
    }
    
    var sourceID : String
    var sourceType : String
    var amount : Int
    var notes : String // 250 char max
    
    func requestPayment() -> Alamofire.Request {
        return Alamofire.request(.POST, DwollaRequest.requestURL, parameters: [
            "sourceId": sourceID,
            "sourceType": sourceType,
            "amount": amount,
            "notes": notes
            ], encoding: .JSON, headers: self.headers)
    }
    
    func requestWasSuccessful(request: Alamofire.Request) {
        request.responseJSON { response in
            let success = (response.response?.allHeaderFields["Success"] as? BooleanType)!
            print(success)
        }
    }
    
    
}
