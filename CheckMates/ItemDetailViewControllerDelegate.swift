//
//  ItemDetailViewControllerDelegate.swift
//  CheckMates
//
//  Created by Greg on 9/28/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation

protocol ItemDetailViewControllerDelegate {
    func existingDataForIndexPath(_ indexPath : IndexPath?) -> (String, Float)?
    func itemDetailViewControllerDidCompleteEditing(description: String, andPrice price: Float, forIndexPath indexPath: IndexPath?, sender: ItemDetailViewController)
    func itemDetailViewControllerDidCancel(_ sender: ItemDetailViewController)
}
