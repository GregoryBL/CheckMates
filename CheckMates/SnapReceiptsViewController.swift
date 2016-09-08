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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventController = EventController()
        eventController.createNewEvent()
        let itemStore = ItemStore()
        itemStore.createItem("Cheese", price: 33.22)
        itemStore.createItem("Meat", price: 199.00)
        itemStore.createItem("Other food", price: 323.00)
        itemStore.createItem("Tax three two", price: 3.99)
        itemStore.createItem("my TIP", price: 9)
        
        eventController.addBillItems(itemStore)
        
        let mate1 = Mate(firstName: "Charles", lastName: "Bruckenheiser", mobileNumber: "3126131481", id: "9439j34", image: nil)
        var mates = [Mate]()
        mates += [mate1]
        eventController.addContacts(mates)
        let contacts = eventController.newEvent?.contacts?.allObjects as! [Contact]
        let items = eventController.newEvent?.receipt?.items?.allObjects as! [ReceiptItem]
        for item in items {
            item.contact = contacts[0]
        }
        eventController.saveEvent()
        
        PaymentsController().createRequestsForEvent(eventController.newEvent!)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(self.pickedPhoto == false) {
            launchCamera()
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
    
        PhotoTakingHelper.snapPhoto(imagePicker)
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func addActivityIndicator() {
        SwiftSpinner.show("Processing Receipt")
    }
    
    func removeActivityIndicator() {
        SwiftSpinner.hide()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // get image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = PhotoTakingHelper.scaleImage(image, maxDimension: 1200)
        
        addActivityIndicator()
        
        imageView.image = scaledImage
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
    
    func performImageRecognition(image: UIImage) {
        itemStore = PhotoTakingHelper.ocrImage(image)
    
        removeActivityIndicator()

        self.performSegueWithIdentifier("DisplayItemsSegue", sender: self)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        // picker cancelled, dismiss picker view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        pickedPhoto = true
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DisplayItemsSegue"
        {
            eventController.createNewEvent()
            let detailViewController = segue.destinationViewController as? DetailedReceiptTableViewController
            detailViewController?.itemStore = itemStore
            detailViewController?.eventController = eventController
        }
    }
    
}
