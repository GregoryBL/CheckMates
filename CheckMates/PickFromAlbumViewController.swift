//
//  SnapReceiptsViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import TesseractOCR

class PickFromAlbumViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var pickedPhoto = false
    var itemStore = ItemStore()
    var activityIndicator:UIActivityIndicatorView!
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(self.pickedPhoto == false) {
            launchCamera()
        }
    }
    
    
    @IBAction func snapReceipt(sender:UIButton!)
    {
        launchCamera()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.pickedPhoto = false
    }
    
    func launchCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(image, maxDimension: 640)
        
        addActivityIndicator()
        
        imageView.image = image
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(image: UIImage) {
        
        itemStore = PhotoTakingHelper.ocrImage(image)
        removeActivityIndicator()

        self.performSegueWithIdentifier("DisplayReceiptFromAlbum", sender: self)
    }
    
    func isPhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        if(phoneTest.evaluateWithObject(value)) {
            return true
        }
        else {
            return false
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        // picker cancelled, dismiss picker view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        pickedPhoto = true
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DisplayReceiptFromAlbum"
        {
            let detailViewController = segue.destinationViewController as? DetailedReceiptTableViewController
            detailViewController?.itemStore = itemStore
        }
    }
    
}
