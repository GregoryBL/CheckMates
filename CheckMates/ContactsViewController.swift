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
    
    var eventController: EventController?
    var mates = [Mate]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            CNContactStore().requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    let contactPicker = CNContactPickerViewController()
                    contactPicker.delegate = self
                    contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
                    
                    self.present(contactPicker, animated: true, completion: nil)
                }
            } as! (Bool, Error?) -> Void)
            
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
            
            self.present(contactPicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        var mobilePhone = String()
        mates = []
        
        for contact in contacts {
           
            for num in contact.phoneNumbers {
                let numVal = (num.value ).value(forKey: "digits") as! String
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
        
        self.performSegue(withIdentifier: "ShowEvent", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvent" {
            let eventViewController = segue.destination as! EventTableViewController
            self.eventController?.addContacts(mates)
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

