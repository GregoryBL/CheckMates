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
    
    var indexPath: IndexPath?
    var item: Item?
    var delegate: ItemDetailViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let existingItem = delegate?.existingItemForIndexPath(indexPath) {
            self.item = existingItem
            titleField.text = item!.title
            priceField.text = item!.price.asLocaleCurrency
            dateField.text = item!.created_at.friendlyDate
            self.title = "Edit Item"
        } else {
            self.title = "New Item"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        
        var isNew = false
        if (item == nil) {
            item = Item(title: titleField.text!, price: priceField.text!.asFloat)
            isNew = true
        } else {
            item!.title = titleField.text!
            item!.price = priceField.text!.asFloat
        }
        delegate?.itemDetailViewControllerDidCompleteEditingItem(item!, new: isNew, sender: self)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


