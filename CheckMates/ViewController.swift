//
//  ViewController.swift
//  CheckMates
//
//  Created by Gregory Berns-Leone on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let moc = UIApplication.sharedApplication().delegate!.coreDataStack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newBill = NSEntityDescription.insertNewObjectForEntityForName("Bill", inManagedObjectContext: AppDelegate.moc) as! Bill
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

