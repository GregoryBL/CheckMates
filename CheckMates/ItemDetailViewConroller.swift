//
//  ItemDetailViewConroller.swift
//  CheckMates
//
//  Created by Amy Plant on 9/5/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController, UITextFieldDelegate {
    
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
                
        // save the changes that were made
        item.title = titleField.text ?? ""
        item.price = priceField.text!.asFloat
    }
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


