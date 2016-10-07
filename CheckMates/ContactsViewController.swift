//
//  ContactsViewController.swift
//  ContactsUITest
//
//  Created by Lauren Daniels on 9/3/16.
//  Copyright © 2016 Lauren Daniels. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UITableViewController {
    
    var eventController: EventController!
    let contactStore = CNContactStore()
    var contactIdentifiers = [String: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true

        let backgroundQueue = DispatchQueue(label: "com.checkmates.backgroundQueue", qos: .background, target: nil)       
        backgroundQueue.sync {
            self.contactIdentifiers = self.getContactIdentifiers()
            print("completed grabbing contacts")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentContacts = eventController.event.contacts?.allObjects as! [Contact]
        for contact in currentContacts {
            let fullName = self.givenNameFor(first: contact.firstName, andLast: contact.lastName)
            let firstLetter = String(fullName[fullName.startIndex])
            
            let section = sortedKeys().index(of: firstLetter)!
            let row = contactIdentifiers[firstLetter]!.index(of: contact.uuid!)!
            tableView.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
        }
    }
    
    func getContactIdentifiers() -> [String: [String]] {
        let keysToFetch = [CNContactIdentifierKey, CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey]
        let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as [CNKeyDescriptor])
        var contactsIdentifiers = [String: [String]]()
        
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault
        
//        let contactStoreID = contactStore.defaultContainerIdentifier()
        
        do {
            try contactStore.enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                if (contact.phoneNumbers != [] && (contact.familyName != "" || contact.givenName != "")) {
                    let fullName = self.givenNameFor(first: contact.givenName, andLast: contact.familyName)
                    let firstLetter = String(fullName[fullName.startIndex])
                    
                    let currentContactsForLetter = contactsIdentifiers[firstLetter]
                    if var contacts = currentContactsForLetter {
                        contacts.append(contact.identifier)
                        contactsIdentifiers[firstLetter] = contacts
                    } else {
                        contactsIdentifiers[firstLetter] = [contact.identifier]
                    }
                }
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        
        return contactsIdentifiers
    }
    
    fileprivate func givenNameFor(first firstName: String?, andLast lastName: String?) -> String {
        var name = ""
        if let first = firstName {
            name = name.appending(first)
        }
        if let last = lastName {
            name = name.appending(" ").appending(last)
        }
        return name
    }
    
    fileprivate func sortedKeys() -> [String] {
        return Array(self.contactIdentifiers.keys).sorted()
    }
    
    // MARK: UITableViewController methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactIdentifiers.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactIdentifiers[sortedKeys()[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sortedKeys()[section])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")
        
        let section = sortedKeys()[indexPath.section]
        
        let ident = contactIdentifiers[section]![indexPath.row]
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey]
        let contact = try? contactStore.unifiedContact(withIdentifier: ident, keysToFetch: keysToFetch as [CNKeyDescriptor])

        cell?.textLabel?.text = givenNameFor(first: contact?.givenName, andLast: contact?.familyName)
        if let contactImage = contact?.imageData {
            cell?.imageView?.image = UIImage(data: contactImage)
        }
        return cell!
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedKeys()
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sortedKeys().index(of: title)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let contactID = contactIdentifiers[sortedKeys()[indexPath.section]]![indexPath.row]
        let contact = try? contactStore.unifiedContact(withIdentifier: contactID, keysToFetch: keysToFetch as [CNKeyDescriptor])
        eventController.addContact(firstName: contact!.givenName, lastName: contact!.familyName, phoneNumber: (contact?.phoneNumbers.first?.value.value(forKey:"digits") as! String), id: contactID)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let contactID = contactIdentifiers[sortedKeys()[indexPath.section]]![indexPath.row]
        eventController.removeContact(id: contactID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvent" {
            let eventViewController = segue.destination as! EventTableViewController
            eventViewController.eventController = self.eventController
        }
    }
}
