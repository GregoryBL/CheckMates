//
//  DetailedReceiptTableViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit


class DetailedReceiptTableViewController: UITableViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    var itemStore = ItemStore()
    var eventController: EventController?
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65

    }
    
    @IBAction func addNewItem(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowItem", sender: self)
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[(indexPath as NSIndexPath).row]
            
            
            let title = "Remove \(item.title)?"
            let message = "Are you sure you want to delete this item?"
            
            let alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive,handler: { (action) -> Void in
                                                                                                self.itemStore.removeItem(item)
                                                                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.updateLabels()
        
        let item = itemStore.allItems[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = item.title
        cell.priceLabel.text = item.price.asLocaleCurrency
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowItem" {
            
            // determine which row was selected
            if let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                
                // get the item associated with this row
                let item = itemStore.allItems[row]
                let backItem = UIBarButtonItem()
                backItem.title = "save"
                navigationItem.backBarButtonItem = backItem
                let detailItemViewController = segue.destination as! ItemDetailViewController
                detailItemViewController.item = item
            }
            else {
                let detailItemViewController = segue.destination as! ItemDetailViewController
                detailItemViewController.item = itemStore.createItem("", price: 0)
                
            }
        }
        else if segue.identifier == "ShowEvent"{
            let contactsViewController = segue.destination as! ContactsViewController
            if self.eventController == nil {
                self.eventController = EventController()
            }
            self.eventController!.addBillItems(itemStore)
            contactsViewController.eventController = eventController
        }
    }
}
