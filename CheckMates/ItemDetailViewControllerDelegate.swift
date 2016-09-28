//
//  ItemDetailViewControllerDelegate.swift
//  CheckMates
//
//  Created by Greg on 9/28/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation

protocol ItemDetailViewControllerDelegate {
    func existingItemForIndexPath(_ indexPath : IndexPath?) -> Item?
    func itemDetailViewControllerDidCompleteEditingItem(_ item : Item, new: Bool, sender: ItemDetailViewController)
    func itemDetailViewControllerDidCancel(_ sender: ItemDetailViewController)
}
