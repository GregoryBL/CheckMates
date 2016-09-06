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
    
    override func viewWillAppear(animated: Bool) {
        
        self.performSegueWithIdentifier("AddReceiptManually", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddReceiptManually"
        {
            let addReceiptManuallyVC = segue.destinationViewController as? DetailedReceiptTableViewController
            addReceiptManuallyVC!.itemStore = itemStore
        }
    }
}
