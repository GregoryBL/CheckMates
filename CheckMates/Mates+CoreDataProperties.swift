//
//  Mates+CoreDataProperties.swift
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

extension Mates {

    @NSManaged var firstName: String
    @NSManaged var id: String
    @NSManaged var lastName: String?
    @NSManaged var mobileNumber: String
    @NSManaged var uiimage: NSData
    @NSManaged var event: Event
    @NSManaged var items: Items?

}
