//
//  MessageController.swift
//  CheckMates
//
//  Created by Lauren Daniels on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import Alamofire

class MessageController {

    func textContacts(collection: [Contact], billId: String) {
        let twilloUsername = valueForAPIKey(named: "TWILIO_ACCT_SID")
        let twilloPassword = valueForAPIKey(named: "TWILIO_AUTH_TOKEN")
        let myGroupMates = dispatch_group_create()
        for recipient in collection {
            let data = [
                "To" : recipient.mobileNumber!,
                "From" : "+13059648615",
                "Body" : "Spilting the bill is easy with CheckMates http://www.checkmatesapp.com/\(billId)/\(recipient.uuid!)"
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

}
