//
//  ServerController.swift
//  CheckMates
//
//  Created by Gregory Berns-Leone on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import Alamofire


class ServerController {
    
    let serverURL = "http://checkmatesapp.herokuapp.com"
    var newBill : Receipt?
    
    func sendNewReceiptToServer(_ receipt : Receipt, sender: EventController) {
        let itemsArray : NSMutableArray = []
        for item in receipt.items! {
            itemsArray.add(itemToItemDict(item as! ReceiptItem))
        }
        let itemsDict : [String: AnyObject] = ["items": itemsArray]
        let toSend : [String: AnyObject]? = ["bill": itemsDict as AnyObject]

        Alamofire.request(serverURL + "/bills", method: .post, parameters: toSend, encoding: JSONEncoding.default)
            .responseData { response in
                print(response.result.value)
                print(response)
                
                print(JSON(data: response.result.value!))
                sender.parseOriginalResponse(response.result.value!)
                sender.sendMessages()
        }
    }
    
    func retrieveReceiptFromServer(_ billID: String, target: EventController) {
        Alamofire.request(serverURL + "/bills/" + billID)
            .responseData { response in
                target.parseJSON(response.result.value!)
        }
    }
    
    func itemToItemDict(_ item : ReceiptItem) -> [String: AnyObject] {
        return [
            "item_description": item.itemDescription! as AnyObject,
            "price": String(item.price) as AnyObject
        ]
    }
}
