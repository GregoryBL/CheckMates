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
    
    @IBAction func completeEvent(sender: UIButton) {
        if (sender.titleLabel?.text == "Done") {
            sender.setTitle("Request Payment", forState:  UIControlState.Normal)
            print("sending ...")
            //Event controller receipt is complete
            // Send messges to Contacts
//        } else if (bill.billItems > 0){
            print("Sending payment requests to mates")
            sender.setTitle("Request Payment", forState:  UIControlState.Normal)
        } else {
            sender.setTitle("Event Closed", forState:  UIControlState.Normal)
            sender.userInteractionEnabled = false
        }

        
        
       
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
    
    func billHasAtLeastOneClaimed(){
           }
    

}

//class Bill: NSObject {
//    var initiator_id: String
//    var billItems: Int
//    
//    init(initiator_id: String, billItems: Int) {
//        self.initiator_id = initiator_id
//        self.billItems = billItems
//        
//        super.init()
//    }
//}