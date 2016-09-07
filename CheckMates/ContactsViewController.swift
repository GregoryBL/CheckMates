//
//  ContactsViewController.swift
//  ContactsUITest
//
//  Created by Lauren Daniels on 9/3/16.
//  Copyright © 2016 Lauren Daniels. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsViewController: UIViewController, CNContactPickerDelegate {
    
    var itemStore: ItemStore!
    var mates = [Mate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
            CNContactStore().requestAccessForEntityType(.Contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    let contactPicker = CNContactPickerViewController()
                    contactPicker.delegate = self
                    contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
                    
                    self.presentViewController(contactPicker, animated: true, completion: nil)
                }
            })
            
        } else if CNContactStore.authorizationStatusForEntityType(.Contacts) == .Authorized {
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
            
            self.presentViewController(contactPicker, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        
        var mobilePhone = String()
        
        for contact in contacts {
            for num in contact.phoneNumbers {
                let numVal = (num.value as! CNPhoneNumber).valueForKey("digits") as! String
                if num.label == CNLabelPhoneNumberMobile || num.label == CNLabelPhoneNumberiPhone {
                    mobilePhone = numVal
                }

                let firstName = contact.givenName
                let lastName = contact.familyName
                let id = contact.identifier
                let image = (contact.isKeyAvailable(CNContactImageDataKey) && contact.imageDataAvailable) ? UIImage(data: contact.imageData!) : nil
                let newMate = Mate(firstName: firstName, lastName: lastName, mobileNumber: mobilePhone, id: id, image: image)
                mates.append(newMate)

                
            }
            
        }
        
        self.performSegueWithIdentifier("ShowEvent", sender: self)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowEvent" {
            let eventViewController = segue.destinationViewController as! EventTableViewController
            eventViewController.mates = mates 
        }
    }
    
}

// TODO -- NEED TO DELETE

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

