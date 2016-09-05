//
//  ItemDetailViewConroller.swift
//  CheckMates
//
//  Created by Amy Plant on 9/5/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet var countField: UITextField!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var dateField:  UILabel!
    
    var item: Item!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        countField.text = "1"
        titleField.text = item.title
        priceField.text = item.price.asLocaleCurrency
        dateField.text = item.created_at.friendlyDate
    }
}


