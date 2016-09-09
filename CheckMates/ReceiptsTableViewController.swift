//
//  ReceiptsViewConroller.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ReceiptsTableViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var eventController: EventController = EventController()
    var events: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View Will Appear")
        events = eventController.fetchAllEvents()
        tableView.reloadData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (eventController.fetchAllEvents().count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReceiptCell")
        let currentEvent = events![indexPath.row] as Event!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        cell?.textLabel!.text = "\(dateFormatter.stringFromDate(NSDate(timeIntervalSince1970:currentEvent.createdAt)))"
        let receiptTotal: Int = (currentEvent.receipt?.receiptTotal(currentEvent))!
        let formatted = Float(receiptTotal) / 100
        cell?.detailTextLabel!.text = "$" + String(formatted)

        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowEventFromReceiptSummary" {
            
            // determine which row was selected
            if let row = tableView.indexPathForSelectedRow?.row {
                
                let backItem = UIBarButtonItem()
                backItem.title = "cancel"
                navigationItem.backBarButtonItem = backItem
                
                // get the item associated with this row
                let event = events![row]
                self.eventController.newEvent = event
                let eventTableViewController = segue.destinationViewController as! EventTableViewController
                eventTableViewController.eventController = self.eventController
                eventTableViewController.titleForCERPButton = "Request Payment"
                
                let apiManager = DwollaAPIManager.sharedInstance
                if !apiManager.hasOAuthToken() && !apiManager.hasRefreshToken() {
                    apiManager.startOAuth2Login()
                }
            }
        
        }
        
    }

}

