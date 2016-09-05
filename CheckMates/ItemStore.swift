//
//  ItemStore.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ItemStore {
    
    var allItems: [Item] = []
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
    func createItem() -> Item {
        print("creating an item")
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
}

