//
//  PhotoTakingHelper.swift
//  CheckMates
//
//  Created by Amy Plant on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit

class PhotoTakingHelper: NSObject, UIImagePickerControllerDelegate {
    
    func snapPhoto() {
        print("snap photo")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
    }
    
}

