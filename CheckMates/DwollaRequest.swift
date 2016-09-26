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
            "Authorization": "Bearer " + token
        ]
    }
    
    var sourceID : String
    var sourceType : String
    var amount : Int
    var notes : String // 250 char max
    var response : DataResponse<Data>?
    
    func requestPayment() -> Request {
        return Alamofire.request(DwollaRequest.requestURL, method: .post, parameters: [
            "sourceId": sourceID,
            "sourceType": sourceType,
            "amount": Double(amount)/100,
            "notes": notes
            ], encoding: JSONEncoding.default, headers: self.headers)
            .responseData { response in
                self.response = response
        }
    }
    
    func responseWasReceived() -> Bool {
        if self.response != nil {
            return true
        }
        return false
    }
    
    func requestWasSuccessful() -> Bool {
        if let success = JSON(data: response!.result.value!)["Success"].bool {
            return success
        }
        return false
    }
    
    
}
