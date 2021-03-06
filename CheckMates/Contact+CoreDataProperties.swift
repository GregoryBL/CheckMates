//
//  Contact+CoreDataProperties.swift
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

extension Contact {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var mobileNumber: String?
    @NSManaged var uiimage: Data?
    @NSManaged var uuid: String?
    @NSManaged var event: Event?
    @NSManaged var items: NSSet?

}
