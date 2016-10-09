//
//  SnapReceiptsViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import TesseractOCR
import SwiftSpinner


class SnapReceiptsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var activityIndicator:UIActivityIndicatorView!
    var eventController = EventController(with: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            launchCamera()
        }
    }
    
    func launchCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addActivityIndicator() {
        SwiftSpinner.show("Processing Receipt")
    }
    
    func removeActivityIndicator() {
        SwiftSpinner.hide()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = PhotoTakingHelper.scaleImage(image, maxDimension: 1200)
        
        self.addActivityIndicator()
        
        dismiss(animated: true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(_ image: UIImage) {
        eventController.addLines(PhotoTakingHelper.ocrImage(image))
    
        removeActivityIndicator()

        self.performSegue(withIdentifier: "DisplayItemsSegue", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // picker cancelled, dismiss picker view controller
        self.dismiss(animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplayItemsSegue"
        {
            let detailViewController = segue.destination as! DetailedReceiptTableViewController
            detailViewController.eventController = eventController
        }
    }
    
}
