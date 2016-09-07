//
//  PhotoTakingHelper.swift
//  CheckMates
//
//  Created by Amy Plant on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import TesseractOCR


class PhotoTakingHelper {
    
    
    class func snapPhoto() {
        print("snap photo")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
    }
    
    class func choosePhoto() {
        
    }
    
    // create the imageStore based on process the text from the image
    
    class func ocrImage(image: UIImage) -> ItemStore {
        
        let itemStore = ItemStore()
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng")
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        let receiptText = tesseract.recognizedText
        let lines = receiptText.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        
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
        
        return itemStore
    }
}

