//
//  Receipt.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import CoreData


class Receipt: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func receiptTotal(_ event:Event) -> Int {
        
        let receiptItems = event.receipt!.items!.allObjects as! [ReceiptItem]
        
        var receiptTotal = 0
        
        for item in receiptItems {
            receiptTotal = receiptTotal + Int(item.price)
        }
        
        return receiptTotal
    }

}
