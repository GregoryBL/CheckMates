
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

class PickFromAlbumViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var pickedPhoto = false
    var itemStore = ItemStore()
    var activityIndicator:UIActivityIndicatorView!
    
//    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchCamera()
    }
    
    @IBAction func snapReceipt(_ sender:UIButton!)
    {
        launchCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.pickedPhoto = false
    }
    
    func launchCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addActivityIndicator() {
        SwiftSpinner.show("Processing Receipt")
    }
    
    func removeActivityIndicator() {
        SwiftSpinner.hide()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print(image)
        let scaledImage = PhotoTakingHelper.scaleImage(image, maxDimension: 640)
        print(scaledImage)

        addActivityIndicator()
        
//        imageView.image = scaledImage
        dismiss(animated: true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(_ image: UIImage) {
        
        itemStore = PhotoTakingHelper.ocrImage(image)
        removeActivityIndicator()

        self.performSegue(withIdentifier: "DisplayReceiptFromAlbum", sender: self)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // picker cancelled, dismiss picker view controller
        self.dismiss(animated: true, completion: nil)
        pickedPhoto = true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplayReceiptFromAlbum"
        {
            let detailViewController = segue.destination as? DetailedReceiptTableViewController
            detailViewController?.itemStore = itemStore
        }
    }
    
}
