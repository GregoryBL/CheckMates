//
//  EventTableViewController.swift
//  CheckMates
//
//  Created by Lauren Daniels on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import Contacts

// NOT READY YET

class EventTableViewController: UITableViewController {
    var eventController: EventController?
    
    @IBAction func completeEvent(sender: UIButton) {
        if (sender.titleLabel?.text == "Done") {
            sender.setTitle("Request Payment", forState:  UIControlState.Normal)
            print("sending ...")
            //Event controller receipt is complete
            // Send messges to Contacts
        } else if (sender.titleLabel?.text == "Request Payment"){
            print("Sending payment requests to mates")
            sender.setTitle("Request Payment", forState:  UIControlState.Normal)
        } else {
            sender.setTitle("Event Closed", forState:  UIControlState.Normal)
            sender.userInteractionEnabled = false
        }

        
        
       
    }
   
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Contacts"
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (eventController?.newEvent!.contacts!.count)!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell")
        let currentMate = eventController?.newEvent!.contacts!.allObjects[indexPath.row] as! Contact!
        cell?.textLabel!.text = "\(currentMate.firstName!) \(currentMate.lastName!)"
        cell?.detailTextLabel!.text = "\(currentMate.mobileNumber!)"
        
       
        return cell!
    }
    

}