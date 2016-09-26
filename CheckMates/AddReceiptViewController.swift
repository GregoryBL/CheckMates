//
//  AddReceiptViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class AddReceiptsViewController: UIViewController {
    
    var itemStore = ItemStore()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.performSegue(withIdentifier: "AddReceiptManually", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddReceiptManually"
        {
            let addReceiptManuallyVC = segue.destination as? DetailedReceiptTableViewController
            addReceiptManuallyVC!.itemStore = itemStore
        }
    }
}
