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
    
    
    class func snapPhoto(imagePicker: UIImagePickerController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        
        
        print("snap photo")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
    }
    
    class func choosePhoto(imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .PhotoLibrary
    }
    
    
    class func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
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
        
    
        for item in lines {
            // http://nshipster.com/nscharacterset/
            let digits = NSCharacterSet.decimalDigitCharacterSet()
            var lineAsString = item
            var title = ""
            var price:Float = 0
            
            // trim white leading and trailing white space
            let components = lineAsString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter { !$0.isEmpty }
            lineAsString = components.joinWithSeparator(" ")
            let lineAsArray = lineAsString.componentsSeparatedByString(" ")
            
            // add item as long as it is not a blank line
            if(lineAsString != "" && lineAsString.rangeOfString("Suite") == nil) {
                if((lineAsString.rangeOfCharacterFromSet(digits)) != nil) {
                    
                    // determine the price assigned to that line
                    let lastDigits = lineAsArray.last!.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "$"))
                    if(lastDigits.asFloat < 999) {
                        price = lastDigits.asFloat
                        
                        // if the first item in the array is not a number, there is probably only one of them
                        if((lineAsArray[0].rangeOfCharacterFromSet(digits)) != nil) {
                            
                            // either the firstValue represents the quantity or an address
                            let components = lineAsArray[0].componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                            let firstNumber = components.joinWithSeparator("").asInteger
                            if(firstNumber < 10) {
                                // the first number is probably the item count, so create the appropriate numbe of items
                                var i = 1
                                while i <= firstNumber {
                                    title = lineAsString
                                    itemStore.createItem(title, price: price)
                                    i += 1
                                }
                            }
                        }
                        else {
                            title = lineAsString
                            itemStore.createItem(title, price: price)
                        }
                    }
                }
            }
        }
        
        return itemStore
    }
}

