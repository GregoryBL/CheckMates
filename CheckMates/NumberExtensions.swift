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
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(self)!
    }
}
