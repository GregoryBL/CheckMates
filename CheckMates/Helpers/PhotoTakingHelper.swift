//
//  PhotoTakingHelper.swift
//  CheckMates
//
//  Created by Amy Plant on 9/7/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import UIKit
import CoreData
import TesseractOCR


class PhotoTakingHelper {
    
    static func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        
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
    
    static func processLine(_ line: String) -> [ReceiptItem] {
        let cds = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
        // http://nshipster.com/nscharacterset/
        let digits = CharacterSet.decimalDigits
        var title = ""
        var price: Float = 0
        var items: [ReceiptItem] = []
        
        // trim white leading and trailing white space
        let components = line.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        let lineAsString = components.joined(separator: " ")
        let lineAsArray = lineAsString.components(separatedBy: " ")
        
        // add item as long as it is not a blank line
        guard lineAsString != "" && lineAsString.range(of: "Suite") == nil else { print("discarding line"); return [] }
        
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
                        // the first number is probably the item count, so create the appropriate number of items
                        var i = 1
                        while i <= firstNumber {
                            title = lineAsString
                            let newItem = NSEntityDescription.insertNewObject(forEntityName: "ReceiptItem", into: cds.mainQueueContext) as! ReceiptItem
                            newItem.itemDescription = title
                            newItem.price = Int64(price/Float(firstNumber) * 100)
                            items.append(newItem)
                            i += 1
                        }
                    }
                }
                else {
                    title = lineAsString
                    let newItem = NSEntityDescription.insertNewObject(forEntityName: "ReceiptItem", into: cds.mainQueueContext) as! ReceiptItem
                    newItem.itemDescription = title
                    newItem.price = Int64(price)
                    items.append(newItem)
                }
            }
        }
        return items
    }
    
    // create the imageStore based on process the text from the image
    
    static func ocrImage(_ image: UIImage) -> [String] {
        let sizedImage = PhotoTakingHelper.scaleImage(image, maxDimension: 640)
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng")
        tesseract.charWhitelist = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$.";
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = sizedImage.g8_blackAndWhite()
        tesseract.recognize()
        
        let receiptText = tesseract.recognizedText
        let lines = receiptText?.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        
        return lines!
    }
}

