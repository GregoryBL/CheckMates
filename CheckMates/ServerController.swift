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
    
    func sendNewReceiptToServer(receipt : Receipt) {
        let itemsArray : NSMutableArray = []
        for item in receipt.items! {
            itemsArray.addObject(itemToItemDict(item as! ReceiptItem))
        }
        let itemsDict : [String: AnyObject] = ["items": itemsArray]
        let toSend : [String: AnyObject]? = ["bill": itemsDict]

        Alamofire.request(.POST, serverURL + "/bills", parameters: toSend, encoding: .JSON)
            .responseJSON { response in
                print(response)
                print(JSON((response.request?.HTTPBody!)!))
        }
        
    }
    
    func updateReceiptAtServer(receipt : Receipt) {
        
    }
    
    func retrieveReceiptFromServer(billID: Int) {
        Alamofire.request(.GET, serverURL + "/bills/" + String(billID))
            .responseJSON { response in
                print(response)
        }
    }
    
    func itemToItemDict(item : ReceiptItem) -> [String: AnyObject] {
        return [
            "item_description": item.itemDescription!,
            "price": String(item.price)
        ]
    }
}