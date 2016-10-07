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

