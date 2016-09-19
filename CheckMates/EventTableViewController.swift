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
    
    @IBAction func completeEvent(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Done") {
            sender.setTitle("Request Payment", for:  UIControlState())
            print("Bill ready to be saved")
            eventController?.billIsComplete()
        } else {
            eventController?.userDidRequestPayment()
            print("Sending payment requests to mates")
            sender.setTitle("Event Closed", for:  UIControlState())
            sender.isUserInteractionEnabled = false
            
        }
    }
    
    override func viewDidLoad() {
        if let buttonTitle = titleForCERPButton {
            completeEventRequestPaymentButton.setTitle(buttonTitle, for:  UIControlState())
            ServerController().retrieveReceiptFromServer((eventController?.newEvent?.receipt?.backEndID!)!, target: eventController!)
            let apiManager = DwollaAPIManager.sharedInstance
            if !apiManager.hasOAuthToken() && apiManager.hasRefreshToken() {
                apiManager.refreshOAuthToken()
            }
        }
    }
    
    @IBOutlet weak var completeEventRequestPaymentButton: UIButton!
   
    @IBAction func editReceiptButton(_ sender: UIButton) {
         // Inactive for demo
        sender.isUserInteractionEnabled = false
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Contacts"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (eventController?.newEvent!.contacts!.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")
        let currentMate = eventController?.newEvent!.contacts!.allObjects[(indexPath as NSIndexPath).row] as! Contact!
        cell?.textLabel!.text = "\(currentMate?.firstName!) \(currentMate?.lastName!)"
        cell?.detailTextLabel!.text = "\(currentMate?.mobileNumber!)"
        
       
        return cell!
    }
    

}
