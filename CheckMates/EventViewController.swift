//
//  EventViewController.swift
//  CheckMates
//
//  Created by Lauren Daniels on 9/6/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import Contacts

class EventViewController: UIViewController, UITableViewDelegate {
    var mates: [Mate] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mates.count
    }
}