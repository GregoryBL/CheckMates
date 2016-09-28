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
    
    var pickedPhoto = false
    var itemStore = ItemStore()
    var activityIndicator:UIActivityIndicatorView!
    var eventController:EventController = EventController()
    
    @IBOutlet var imageView: UIImageView!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(UIImagePickerController.isSourceTypeAvailable(.camera) && self.pickedPhoto == false) {
            launchCamera()
            self.pickedPhoto = true
        }
    }
    
    @IBAction func snapReceipt(_ sender:UIButton!)
    {
        launchCamera()
    }
    
    func launchCamera() {
        let imagePicker = UIImagePickerController()
    
        PhotoTakingHelper.snapPhoto(imagePicker)
        
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addActivityIndicator() {
        SwiftSpinner.show("Processing Receipt")
    }
    
    func removeActivityIndicator() {
        SwiftSpinner.hide()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.pickedPhoto = true
        // get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = PhotoTakingHelper.scaleImage(image, maxDimension: 1200)
        
        DispatchQueue.global(qos: .background).async { self.addActivityIndicator() }
        
        imageView.image = scaledImage
        dismiss(animated: true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(_ image: UIImage) {
        itemStore = PhotoTakingHelper.ocrImage(image)
    
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
            eventController.createNewEvent()
            let detailViewController = segue.destination as? DetailedReceiptTableViewController
            detailViewController?.itemStore = itemStore
            detailViewController?.eventController = eventController
        }
    }
    
}
