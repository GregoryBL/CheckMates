//
//  ReceiptsViewConroller.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ReceiptsTableViewController: UITableViewController {
    
    var eventController: EventController!
    var events: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = EventController.fetchAllEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        events = EventController.fetchAllEvents()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell")
        let currentEvent = events[(indexPath as NSIndexPath).row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = Date(timeIntervalSinceReferenceDate: currentEvent.createdAt)
        
        cell?.textLabel!.text = dateFormatter.string(from: date)
        if let receipt = currentEvent.receipt {
            let receiptTotal = receipt.receiptTotal()
            let formatted = Float(receiptTotal) / 100
            cell?.detailTextLabel!.text = "$" + String(formatted)
        }
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventFromReceiptSummary" {
            if let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                let event = events[row]
                self.eventController = EventController(with: event)
                self.eventController.event = event
                
                let eventTableViewController = segue.destination as! EventTableViewController
                eventTableViewController.eventController = self.eventController

                let apiManager = DwollaAPIManager.sharedInstance
                if !apiManager.hasOAuthToken() && !apiManager.hasRefreshToken() {
                    apiManager.startOAuth2Login()
                }
            }
        }
    }
    
    @IBAction func cancelToReceiptsTableViewController(segue:UIStoryboardSegue) {
        EventController.clearContext()
    }
}

