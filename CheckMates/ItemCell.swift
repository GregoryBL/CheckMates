//
//  ItemCell.swift
//  CheckMates
//
//  Created by Amy Plant on 9/5/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        titleLabel.font = bodyFont
        priceLabel.font = bodyFont
    }
    
}