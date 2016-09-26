//
//  ItemDetailViewConroller.swift
//  CheckMates
//
//  Created by Amy Plant on 9/5/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var dateField:  UILabel!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(item != nil) {
            titleField.text = item.title
            priceField.text = item.price.asLocaleCurrency
            dateField.text = item.created_at.friendlyDate
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        if(item == nil) {
            // add a new item
            item = Item(title: titleField.text!, price: priceField.text!.asFloat)
        }
        else {
            // save the changes that were made
            item.title = titleField.text ?? ""
            item.price = priceField.text!.asFloat
        }
        
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


