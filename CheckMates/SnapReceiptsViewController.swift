//
//  SnapReceiptsViewController.swift
//  CheckMates
//
//  Created by Amy Plant on 9/4/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import TesseractOCR

class SnapReceiptsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var pickedPhoto = false
    var itemStore = ItemStore()
    var activityIndicator:UIActivityIndicatorView!
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(self.pickedPhoto == false) {
            launchCamera()
        }
    }
    
    func launchCamera() {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
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
        self.pickedPhoto = true
        
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(image: UIImage) {
        let tesseract:G8Tesseract = G8Tesseract(language:"eng")
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        removeActivityIndicator()
        
        let receiptText = tesseract.recognizedText
        let lines = receiptText.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        

        for item in lines {
            print(item)
            // line.split {$0 == " "} - split words by spaces
            itemStore.createItem(item, price: 0)
        }
        

        
        
        
        
        
        
        
        self.performSegueWithIdentifier("DisplayItemsSegue", sender: self)
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
        
        if segue.identifier == "DisplayItemsSegue"
        {
            let detailViewController = segue.destinationViewController as? DetailedReceiptTableViewController
            detailViewController?.itemStore = itemStore
        }
    }
    
}
