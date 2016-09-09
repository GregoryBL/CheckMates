//
//  ReceiptsViewConroller.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ReceiptsTableViewController: UITableViewController {
    
    var eventController: EventController = EventController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View Will Appear")
        eventController.fetchAllEvents()
        view.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (eventController.fetchAllEvents().count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReceiptCell")
        let currentEvent = eventController.fetchAllEvents()[indexPath.row] as Event!
        cell?.textLabel!.text = "\(currentEvent.createdAt)"
        cell?.detailTextLabel!.text = "\(currentEvent.receipt?.receiptTotal(currentEvent))"
        
        return cell!
    }
    
}
