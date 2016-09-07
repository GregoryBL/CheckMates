//
//  EventTableViewController.swift
//  CheckMates
//
//  Created by Lauren Daniels on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import Contacts

class EventTableViewController: UITableViewController {
    var mates: [Mate] = []
    
    @IBAction func sendReceipt() {
        print("sending ...")
        performSegueWithIdentifier("ShowReceipts", sender: nil)
    }
 
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell")
        let currentMate = mates[indexPath.row]
       
        cell?.textLabel!.text = "\(currentMate.firstName) \(currentMate.lastName)"
        cell?.detailTextLabel!.text = "\(currentMate.mobileNumber)"
        
       
        return cell!
    }
    

}