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
    var eventController: EventController?
    var titleForCERPButton : String?
    
    @IBAction func completeEvent(sender: UIButton) {
        if (sender.titleLabel?.text == "Done") {
            sender.setTitle("Request Payment", forState:  UIControlState.Normal)
            print("Bill ready to be saved")
            eventController?.billIsComplete()
        } else {
            eventController?.userDidRequestPayment()
            print("Sending payment requests to mates")
            sender.setTitle("Event Closed", forState:  UIControlState.Normal)
            sender.userInteractionEnabled = false
            
        }
    }
    
    override func viewDidLoad() {
        if let buttonTitle = titleForCERPButton {
            completeEventRequestPaymentButton.setTitle(buttonTitle, forState:  UIControlState.Normal)
            ServerController().retrieveReceiptFromServer((eventController?.newEvent?.receipt?.backEndID!)!, eventController!)
            let apiManager = DwollaAPIManager.sharedInstance
            if !apiManager.hasOAuthToken() {
                apiManager.refreshOAuthToken()
            }
        }
    }
    
    @IBOutlet weak var completeEventRequestPaymentButton: UIButton!
   
    @IBAction func editReceiptButton(sender: UIButton) {
         // Inactive for demo
        sender.userInteractionEnabled = false
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