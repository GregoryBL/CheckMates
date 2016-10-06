//
//  DetailedReceiptTableViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit


class DetailedReceiptTableViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var eventController: EventController!
    var items: [ReceiptItem]?
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadTableView()
    }
    
    func reloadTableView() {
        items = eventController.event.receipt?.items?.allObjects as? [ReceiptItem]
        tableView.reloadData()
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items![indexPath.row]
            
            let title = "Remove \(item.itemDescription!)?"
            let message = "Are you sure you want to delete this item?"
            
            let alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.eventController.deleteReceiptItem(self.items![indexPath.row])
                self.items?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)

//                self.reloadTableView()
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) // as! ItemCell
        
        let item = items![indexPath.row]
        
        print(item)
        
        cell.textLabel?.text = item.itemDescription
        cell.detailTextLabel?.text = (Float(item.price) / 100).asLocaleCurrency
        
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
            contactsViewController.eventController = eventController
        }
    }
    
    @IBAction func cancelToDetailedReceiptsViewController(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: ItemDetailViewControllerDelegate
    
    func itemDetailViewControllerDidCompleteEditing(description: String, andPrice price: Float, forIndexPath indexPath: IndexPath?, sender: ItemDetailViewController) {
        print(indexPath)
        if (indexPath != nil) {
            if (description == "" || price == 0.0) {
                print("received blank item")
                return
            }
            eventController.addReceiptItem(description, price: Int64(price * 100))
            print("reload tableView")
            reloadTableView()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewControllerDidCancel(_ sender: ItemDetailViewController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func existingDataForIndexPath(_ indexPath : IndexPath?) -> (String, Float)? {
        if let row = indexPath?.row {
            let receiptItem = eventController.event.receipt?.items?.allObjects[row] as! ReceiptItem
            return (receiptItem.itemDescription!, Float(receiptItem.price / 100))
        } else {
            return nil
        }
    }
}
