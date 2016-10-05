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
    
    var eventController: EventController?
    var mates = [Mate]()
    let contactStore = CNContactStore()
    var contactIdentifiers = [String: [String]]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let backgroundQueue = DispatchQueue(label: "com.checkmates.backgroundQueue", qos: .background, target: nil)
        
        backgroundQueue.sync {
            self.contactIdentifiers = self.getContactIdentifiers()
            print("completed grabbing contacts")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
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
    
    private func givenNameFor(first firstName: String?, andLast lastName: String?) -> String {
        var name = ""
        if let first = firstName {
            name = name.appending(first)
        }
        if let last = lastName {
            name = name.appending(" ").appending(last)
        }
        return name
    }
    
    private func sortedKeys() -> [String] {
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
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
        let contact = try? contactStore.unifiedContact(withIdentifier: ident, keysToFetch: keysToFetch as [CNKeyDescriptor])

        cell?.textLabel?.text = givenNameFor(first: contact?.givenName, andLast: contact?.familyName)
        
        return cell!
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedKeys()
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sortedKeys().index(of: title)!
    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//
//        var mobilePhone = String()
//        mates = []
//        
//        for contact in contacts {
//           
//            for num in contact.phoneNumbers {
//                let numVal = (num.value ).value(forKey: "digits") as! String
//                if num.label == CNLabelPhoneNumberMobile || num.label == CNLabelPhoneNumberiPhone {
//                    mobilePhone = numVal
//                }
//
//                let firstName = contact.givenName
//                let lastName = contact.familyName
//                let id = contact.identifier
//                let image = (contact.isKeyAvailable(CNContactImageDataKey) && contact.imageDataAvailable) ? UIImage(data: contact.imageData!) : nil
//                let newMate = Mate(firstName: firstName, lastName: lastName, mobileNumber: mobilePhone, id: id, image: image)
//                mates.append(newMate)
//
//                
//            }
//            
//        }
//        
//        self.performSegue(withIdentifier: "ShowEvent", sender: self)
//
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvent" {
            let eventViewController = segue.destination as! EventTableViewController
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            let selected = tableView.indexPathsForSelectedRows
            var mates = [Mate]()
            if (selected != nil) {
                for indPath in selected! {
                    let contactID = contactIdentifiers[sortedKeys()[indPath.section]]![indPath.row]
                    let contact = try? contactStore.unifiedContact(withIdentifier: contactID, keysToFetch: keysToFetch as [CNKeyDescriptor])
                    mates.append(Mate(firstName: contact!.givenName, lastName: contact!.familyName, mobileNumber: contact!.phoneNumbers.first!.value.stringValue, id: contactID, image: nil))
                }
            }
            self.eventController!.addContacts(mates)
            eventViewController.eventController = self.eventController
        }
    }
    
}

class Mate: NSObject {
    var firstName: String
    var lastName: String
    var mobileNumber: String
    var id: String
    var image: UIImage?
    
    init(firstName: String, lastName: String, mobileNumber: String, id: String, image: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        self.id = id
        self.image = image
        
        super.init()
    }
}

