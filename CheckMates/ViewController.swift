//
//  ViewController.swift
//  CheckMates
//
//  Created by Gregory Berns-Leone on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DwollaAPIManager.sharedInstance.processOAuthStep1Response(NSURL(string:"https://www.gmail.com")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

