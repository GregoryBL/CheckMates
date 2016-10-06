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
    var eventController: EventController!
    
    override func viewDidLoad() {
        self.navigationController?.setToolbarHidden(false, animated: true)
        // If coming from ReceiptsViewController (not modal), update from server
        if self.navigationController?.presentingViewController == nil {
            if let backEndID = eventController.event.receipt?.backEndID {
                print("had backendID")
                ServerController().retrieveReceiptFromServer(backEndID, target: eventController)
            } else {
                print("sent off new bill")
                eventController.billIsComplete()
            }
        }
        let apiManager = DwollaAPIManager.sharedInstance
        if !apiManager.hasOAuthToken() && apiManager.hasRefreshToken() {
            apiManager.refreshOAuthToken()
        }
    }
    
    @IBAction func completeEvent(_ sender: UIBarButtonItem) {
        print("complete event called")
        eventController.billIsComplete()
    }
    
    @IBAction func editReceiptButton(_ sender: UIButton) {
         // Inactive for demo
        sender.isUserInteractionEnabled = false
    }
    
    // MARK: UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Contacts"
        case 1:
            return "Items"
        default:
            print("Too many sections in EventTableViewController: \(section)")
            return"Error"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return eventController.event.contacts!.count
        case 1:
            return eventController.event.receipt!.items!.count
        default:
            print("Too many sections in EventTableViewController: \(section)")
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")
        switch indexPath.section {
        case 0:
            let currentMate = eventController.event.contacts!.allObjects[indexPath.row] as! Contact
            cell?.textLabel!.text = "\(currentMate.firstName!) \(currentMate.lastName!)"
            cell?.detailTextLabel!.text = "\(currentMate.mobileNumber!)"
        case 1:
            let currentItem = eventController.event.receipt!.items!.allObjects[indexPath.row] as! ReceiptItem
            cell?.textLabel!.text = currentItem.itemDescription
            cell?.detailTextLabel!.text = (Float(currentItem.price) / 100).asLocaleCurrency
        default:
            print(indexPath.section)
            print("Too many sections in EventTableViewController")
        }
       
        return cell!
    }
    

}
