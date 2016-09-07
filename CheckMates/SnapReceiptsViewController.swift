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

class EventController {
    
}

class SnapReceiptsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pickedPhoto = false
    var itemStore = ItemStore()
    var activityIndicator:UIActivityIndicatorView!
    var eventController:EventController? = nil
    
    @IBOutlet var imageView: UIImageView!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventController = EventController()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(self.pickedPhoto == false) {
            launchCamera()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.pickedPhoto = false
    }
    
    @IBAction func snapReceipt(sender:UIButton!)
    {
        launchCamera()
    }
    
    func launchCamera() {
        let imagePicker = UIImagePickerController()
    
        PhotoTakingHelper.snapPhoto(imagePicker)
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func addActivityIndicator() {
        SwiftSpinner.show("Processing Receipt")
    }
    
    func removeActivityIndicator() {
        SwiftSpinner.hide()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = PhotoTakingHelper.scaleImage(image, maxDimension: 1200)
        
        addActivityIndicator()
        
        imageView.image = scaledImage
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(image: UIImage) {
        itemStore = PhotoTakingHelper.ocrImage(image)
    
        removeActivityIndicator()

        self.performSegueWithIdentifier("DisplayItemsSegue", sender: self)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        // picker cancelled, dismiss picker view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        pickedPhoto = true
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DisplayItemsSegue"
        {
            let detailViewController = segue.destinationViewController as? DetailedReceiptTableViewController
            detailViewController?.itemStore = itemStore
            detailViewController?.eventController = eventController
        }
    }
    
}
