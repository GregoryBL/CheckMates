//
//  DetailedReceiptTableViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit


class DetailedReceiptTableViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var itemStore = ItemStore()
    var eventController: EventController!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if eventController == nil {
            self.eventController = EventController(with: nil)
        }
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
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.itemStore.removeItem(item)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) // as! ItemCell
        
        let item = itemStore.allItems[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.price.asLocaleCurrency
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowItem" {
            let detailItemViewController = segue.destination as! ItemDetailViewController
            detailItemViewController.delegate = self
            detailItemViewController.indexPath = tableView.indexPathForSelectedRow
        }
        else if segue.identifier == "ChooseContacts"{
            let contactsViewController = segue.destination as! ContactsViewController
            self.eventController.addBillItems(itemStore)
            contactsViewController.eventController = eventController
        }
    }
    
    @IBAction func cancelToDetailedReceiptsViewController(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: ItemDetailViewControllerDelegate
    
    func itemDetailViewControllerDidCompleteEditingItem(_ item : Item, new: Bool, sender: ItemDetailViewController) {
        if (new) {
            if (item.title == "" || item.price == 0.0) {
                print("received blank item")
                return
            }
            _ = self.itemStore.createItem(item.title, price: item.price)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewControllerDidCancel(_ sender: ItemDetailViewController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func existingItemForIndexPath(_ indexPath : IndexPath?) -> Item? {
        if let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
            return itemStore.allItems[row]
        } else {
            return nil
        }
    }
}
