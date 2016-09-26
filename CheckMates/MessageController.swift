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

    func textContacts(_ collection: [Contact], billId: String) {
        let twilloUsername = valueForAPIKey(named: "TWILIO_ACCT_SID")
        let twilloPassword = valueForAPIKey(named: "TWILIO_AUTH_TOKEN")
        let myGroupMates = DispatchGroup()
        for recipient in collection {
            let data = [
                "To" : recipient.mobileNumber!,
                "From" : "+13059648615",
                "Body" : "Spilting the bill is easy with CheckMates http://checkmatesapp.com/bills/\(billId)/users/\(recipient.uuid!)"
            ]
            myGroupMates.enter()
            Alamofire.request("https://\(twilloUsername):\(twilloPassword)@api.twilio.com/2010-04-01/Accounts/\(twilloUsername)/Messages", method: .post, parameters: data)
                .responseJSON { response in
                myGroupMates.leave()
                
                print("Twilio send to \(recipient.mobileNumber!)")
            }
            myGroupMates.notify(queue: DispatchQueue.main, execute: {
                print("Finished all requests.")
            })
        }
    }

}
