//
//  NumberExtensions.swift
//  CheckMates
//
//  Created by Amy Plant on 9/5/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

extension Float {
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "" 
        formatter.currencyGroupingSeparator = ""
        return formatter.string(from: NSNumber(self))!
    }
}

extension String {
    var asFloat: Float {
        return (self as NSString).floatValue
    }
    
    var asInteger: Int {
        return (self as NSString).integerValue
    }
}
