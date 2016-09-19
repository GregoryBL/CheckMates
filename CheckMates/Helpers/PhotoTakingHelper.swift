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
    
    
    class func snapPhoto(_ imagePicker: UIImagePickerController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        
        
        
        print("snap photo")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
    }
    
    class func choosePhoto(_ imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .photoLibrary
    }
    
    
    class func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        
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
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    // create the imageStore based on process the text from the image
    
    class func ocrImage(_ image: UIImage) -> ItemStore {
        
        let itemStore = ItemStore()
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng")
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        let receiptText = tesseract.recognizedText
        let lines = receiptText?.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        
    
        for item in lines! {
            // http://nshipster.com/nscharacterset/
            let digits = CharacterSet.decimalDigits
            var lineAsString = item
            var title = ""
            var price:Float = 0
            
            // trim white leading and trailing white space
            let components = lineAsString.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
            lineAsString = components.joined(separator: " ")
            let lineAsArray = lineAsString.components(separatedBy: " ")
            
            // add item as long as it is not a blank line
            if(lineAsString != "" && lineAsString.range(of: "Suite") == nil) {
                if((lineAsString.rangeOfCharacter(from: digits)) != nil) {
                    
                    // determine the price assigned to that line
                    let lastDigits = lineAsArray.last!.trimmingCharacters(in: CharacterSet.init(charactersIn: "$"))
                    if(lastDigits.asFloat < 999) {
                        price = lastDigits.asFloat
                        
                        // if the first item in the array is not a number, there is probably only one of them
                        if((lineAsArray[0].rangeOfCharacter(from: digits)) != nil) {
                            
                            // either the firstValue represents the quantity or an address
                            let components = lineAsArray[0].components(separatedBy: CharacterSet.decimalDigits.inverted)
                            let firstNumber = components.joined(separator: "").asInteger
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

