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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("View Will Appear")
        events = eventController.fetchAllEvents()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (eventController.fetchAllEvents().count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell")
        let currentEvent = events![(indexPath as NSIndexPath).row] as Event!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        cell?.textLabel!.text = "09-09-2016"
        let receiptTotal: Int = (currentEvent?.receipt?.receiptTotal(currentEvent!))!
        let formatted = Float(receiptTotal) / 100
        cell?.detailTextLabel!.text = "$" + String(formatted)

        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowEventFromReceiptSummary" {
            
            // determine which row was selected
            if let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
//                print(row)
                
                // get the item associated with this row
                let event = events![row]
                self.eventController.newEvent = event
                let eventTableViewController = segue.destination as! EventTableViewController
                eventTableViewController.eventController = self.eventController
//                eventTableViewController.titleForCERPButton = "Request Payment"
                
                let apiManager = DwollaAPIManager.sharedInstance
                if !apiManager.hasOAuthToken() && !apiManager.hasRefreshToken() {
                    apiManager.startOAuth2Login()
                }
            }
        
        }
        
    }
    
    @IBAction func cancelToReceiptsTableViewController(segue:UIStoryboardSegue) {
        
    }

}

