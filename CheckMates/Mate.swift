//
//  Mate.swift
//  CheckMates
//
//  Created by Keith Pilson on 9/5/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation
import CoreData


class Mate: NSManagedObject {

    var fullName : String {
        get {
            if let last = lastName{
                return "\(firstName) \(last)"
            } else {
                return firstName
            }
        }
    }

}