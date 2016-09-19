//
//  Item.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class Item: NSObject {
    
    var title: String
    var price: Float
    var created_at: Date
    
    init(title: String, price: Float) {
        self.title = title
        self.price = price
        self.created_at = Date()
        
        super.init()
    }
    
}


