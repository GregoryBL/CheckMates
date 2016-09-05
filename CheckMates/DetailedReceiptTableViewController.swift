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
            itemStore.removeItem(item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        let item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = "$\(item.price)"
        
        return cell
    }

}
