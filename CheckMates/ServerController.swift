//
//  ServerController.swift
//  CheckMates
//
//  Created by Gregory Berns-Leone on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ServerController {
    
    let serverURL = "http://checkmatesapp.herokuapp.com"
    var newBill : Receipt?
    
    func sendNewReceiptToServer(receipt : Receipt, sender: EventController) {
        let itemsArray : NSMutableArray = []
        for item in receipt.items! {
            itemsArray.addObject(itemToItemDict(item as! ReceiptItem))
        }
        let itemsDict : [String: AnyObject] = ["items": itemsArray]
        let toSend : [String: AnyObject]? = ["bill": itemsDict]

        Alamofire.request(.POST, serverURL + "/bills", parameters: toSend, encoding: .JSON)
            .responseData { response in
                print(response.result.value)
                print(response)
                
                print(JSON(data: response.result.value!))
                sender.parseOriginalResponse(response.result.value!)
                sender.sendMessages()
        }
    }
    
    func retrieveReceiptFromServer(billID: String, target: EventController) {
        Alamofire.request(.GET, serverURL + "/bills/" + billID)
            .responseData { response in
                target.parseJSON(response.result.value!)
        }
    }
    
    func itemToItemDict(item : ReceiptItem) -> [String: AnyObject] {
        return [
            "item_description": item.itemDescription!,
            "price": String(item.price)
        ]
    }
}