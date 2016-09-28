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
    
    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        if(item == nil) {
            item = Item(title: titleField.text!, price: priceField.text!.asFloat)
        } else {
            item.title = titleField.text ?? ""
            item.price = priceField.text!.asFloat
        }
        self.dismiss(animated:true, completion: nil)
    }
    
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


