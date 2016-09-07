//
//  ReceiptItem+CoreDataProperties.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ReceiptItem {

    @NSManaged var itemDescription: String?
    @NSManaged var price: Int64
    @NSManaged var contact: NSManagedObject?
    @NSManaged var receipt: Receipt?

}
