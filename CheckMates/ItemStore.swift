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
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can re-insert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.removeAtIndex(fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, atIndex: toIndex)
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(item: Item) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
}

