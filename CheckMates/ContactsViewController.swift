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
import Alamofire




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
//        let myMates = dispatch_group_create()
        
        for contact in contacts {
            for num in contact.phoneNumbers {
                let numVal = (num.value as! CNPhoneNumber).valueForKey("digits") as! String
                if num.label == CNLabelPhoneNumberMobile || num.label == CNLabelPhoneNumberiPhone {
                    mobilePhone = numVal
                }
//                dispatch_group_enter(myMates)
                let firstName = contact.givenName
                let lastName = contact.familyName
                let id = contact.identifier
                let image = (contact.isKeyAvailable(CNContactImageDataKey) && contact.imageDataAvailable) ? UIImage(data: contact.imageData!) : nil
                let newMate = Mate(firstName: firstName, lastName: lastName, mobileNumber: mobilePhone, id: id, image: image)
                mates.append(newMate)
//                dispatch_group_leave(myMates)
                print("\(newMate.firstName)")
                print("\(newMate.mobileNumber)")
                print(mates.count)
                
            }
            
        }
        
        self.performSegueWithIdentifier("ShowEvent", sender: self)
        //        readyToSend(mates)
    }
    
    // Move this method to event controller
    
    func readyToSend(collection: [Mate]) {
        let twilloUsername = valueForAPIKey(named: "TWILIO_ACCT_SID")
        let twilloPassword = valueForAPIKey(named: "TWILIO_AUTH_TOKEN")
        let myGroupMates = dispatch_group_create()
        for recipient in collection {
            let data = [
                "To" : recipient.mobileNumber,
                "From" : "+13059648615",
                // NEED TO BUILD CUSTOM URL FOR EACH
                "Body" : "Check out CheckMates http://localhost:3000"
            ]
            dispatch_group_enter(myGroupMates)
            Alamofire.request(.POST, "https://\(twilloUsername):\(twilloPassword)@api.twilio.com/2010-04-01/Accounts/\(twilloUsername)/Messages", parameters: data).responseJSON { response in
                dispatch_group_leave(myGroupMates)
                
                print("Twilio send to \(recipient.mobileNumber)")
            }
            dispatch_group_notify(myGroupMates, dispatch_get_main_queue(), {
                print("Finished all requests.")
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowEvent" {
            let eventViewController = segue.destinationViewController as! EventTableViewController
            eventViewController.mates = mates 
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

