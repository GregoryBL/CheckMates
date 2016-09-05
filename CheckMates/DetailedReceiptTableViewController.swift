//
//  DetailedReceiptTableViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class DetailedReceiptTableViewController: UITableViewController {
    
    var receiptText:String = ""
    var itemStore = ItemStore()
    
    @IBAction func addNewItem(sender: AnyObject) {
        // Create a new Item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            // Insert this new row into the table.
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
    // If you are currently in editing mode...
    if editing {
        // Change text of button to inform user of state
        sender.setTitle("Edit", forState: .Normal)
        
        // Turn off editing mode
        setEditing(false, animated: true)
    }
    else {
        // Change text of button to inform user of state
        sender.setTitle("Done", forState: .Normal)
        
        // Enter editing mode
        setEditing(true, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            
            
            let title = "Remove \(item.title)?"
            let message = "Are you sure you want to delete this item?"
            
            let alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive,handler: { (action) -> Void in
                                                                                                self.itemStore.removeItem(item)
                                                                                                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            alertController.addAction(deleteAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        cell.updateLabels()
        
        let item = itemStore.allItems[indexPath.row]
        
        cell.itemCount.text = "1"
        cell.titleLabel.text = item.title
        cell.priceLabel.text = item.price.asLocaleCurrency
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowItem" {
            
            // determine which row was selected
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // get the item associated with this row
                let item = itemStore.allItems[row]
                let detailItemViewController = segue.destinationViewController as! ItemDetailViewController
                detailItemViewController.item = item
            }
        }
    }

}
