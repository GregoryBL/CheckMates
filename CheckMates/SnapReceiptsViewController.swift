//
//  SnapReceiptsViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class SnapReceiptsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DwollaAPIManager.sharedInstance.startOAuth2Login()
        print("sent off")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
