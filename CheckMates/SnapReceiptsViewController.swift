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
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(self.pickedPhoto == false) {
            launchCamera()
            //photoTakingHelper?.snapPhoto()
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
            // http://nshipster.com/nscharacterset/
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            
            var lineAsString = item
            var count = 1
            var title = ""
            var price:Float = 0
            
            
            
            // trim white leading and trailing white space
            let components = lineAsString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter { !$0.isEmpty }
            lineAsString = components.joinWithSeparator(" ")
            let lineAsArray = lineAsString.componentsSeparatedByString(" ")
            // add item as long as it is not a blank line
            if(lineAsString != "") {
                if((lineAsString.rangeOfCharacterFromSet(digits)) != nil) {
                    let lastDigits = lineAsArray.last!.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "$"))
                    if(isPhoneNumber(lastDigits) == false) {
                        price = lastDigits.asFloat
                    }
                    if((lineAsArray[0].rangeOfCharacterFromSet(digits)) != nil) {
                        count = lineAsArray[0].asInteger
                    }
                    title = lineAsString
                    itemStore.createItem(title, price: price)
                }
            }
        }
        
        self.performSegueWithIdentifier("DisplayItemsSegue", sender: self)
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
        
        if segue.identifier == "DisplayItemsSegue"
        {
            let detailViewController = segue.destinationViewController as? DetailedReceiptTableViewController
            detailViewController?.itemStore = itemStore
        }
    }
    
}
