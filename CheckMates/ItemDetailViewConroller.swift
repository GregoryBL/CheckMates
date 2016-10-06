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
    
    var indexPath: IndexPath?
    var delegate: ItemDetailViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let (description, price) = delegate?.existingDataForIndexPath(indexPath) {
            titleField.text = description
            priceField.text = price.asLocaleCurrency
            self.title = "Edit Item"
        } else {
            self.title = "New Item"
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        delegate?.itemDetailViewControllerDidCompleteEditing(description: titleField.text!, andPrice: priceField.text!.asFloat, forIndexPath: indexPath, sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


