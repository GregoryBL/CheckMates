//
//  Bill+CoreDataProperties.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/5/16.
//  Copyright © 2016 checkMates. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bill {

    @NSManaged var createdAt: NSTimeInterval
    @NSManaged var items: NSSet?

}