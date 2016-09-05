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
    var created_at: NSDate
    
    init(title: String, price: Float) {
        self.title = title
        self.price = price
        self.created_at = NSDate()
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let itemNames = ["Mini Donut - Espresso", "Mini Donut - Peanut", "Cold Brew", "Americano"]
            let index = arc4random_uniform(UInt32(itemNames.count))
            let randomName = itemNames[Int(index)]
            let randomValue = Float(arc4random_uniform(1000)/100)
            
            self.init(title: randomName, price: randomValue)
        }
        else {
            self.init(title: "", price: 0)
        }
    }
}


