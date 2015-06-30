//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Lakshmi Vineeth on 6/23/15.
//  Copyright (c) 2015 Lakshmi. All rights reserved.
//

import AVFoundation
import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var topDistance: NSLayoutConstraint!
    @IBOutlet weak var bottomDistance: NSLayoutConstraint!
    
    // Array of Meme type
    var memes: [Meme]!
    
    // Meme to be edited which will be set in Meme Detail page
    var meme: Meme!
    
    
    // Define text style for Top and Bottom text fields
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load shared meme array object from app Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // Set delegate for textfield as EditorViewController
        topText.delegate = self
        bottomText.delegate = self
        
        // Set placeholder text in textfield
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Subscribe to keyboard notification to move frame
        self.subscribeToKeyboardNotifications()
        
        
        // if meme sent from Meme Details Edit option, load that image
        
        if let editMeme = self.meme {
            imageView.image = editMeme.image
            topText.text = editMeme.topText
            bottomText.text = editMeme.bottomText
            self.meme = nil
        }
        
        // Enable share button only after user selects image
        if let _ = imageView.image {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }
        
        // Set text attritubutes
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        // Set alignment of textFields
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        
        // Set minimum font size
        topText.minimumFontSize = 20
        bottomText.minimumFontSize = 20
        
        // Disable camera button when not available on device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    override func viewWillDisappear(animated: Bool) {
        // Unsubscribe to keyboard notification
        self.unsubscribeToKeyboardNotifications()
    }
   
    
    /* This Action will open either the photo library or the camera depending on source type decided by the sender argument */
    @IBAction func createSelectImages(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        switch(sender) {
        case cameraButton:
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        default:
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func shareMemeImage(sender: UIBarButtonItem) {
        
        // Generate meme
        let memeImage = generateMemeImage()
        
        // Pass meme to UIActivityViewController
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                // Save meme in shared meme array object in AppDelegate
                self.saveMemeImage(memeImage)
                self.performSegueWithIdentifier("showSentMemes", sender: self)
            }
        }
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"

    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        let addedText = textField.text as NSString
//        let textSize: CGSize = addedText.sizeWithAttributes(memeTextAttributes)
//        
//        let xImage = self.imageView.frame.origin.x
//        let finalX = self.imageView.image?.size.width
//
//        //
//        
//        if (textSize.width < textField.frame.size.width) && (finalX > textFieldWidth.constant && textFieldWidth.constant > xImage){
//            textFieldWidth.constant += 10
//        } else {
//           textFieldWidth.constant = finalX
//        }

        return true
    }
    
    
    
    // Add observers for keyboard show and hide event
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // Remove observers for keyboard show and hide event
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // Returns height of keyboard
    func getKeyboardHeight(notification : NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    // Adjust view height when bottom textField is first responder and keyboard show
    func keyboardWillShow(notification : NSNotification) {
        if bottomText.isFirstResponder() {
             self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
   // Restore view height when bottom textField is first responder and keyboard hides
    func keyboardWillHide(notification : NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // Generate meme
    func generateMemeImage() -> UIImage {
        
        
        toolbar.hidden = true
        
        // Adjust textfield position on top of image
        moveTextFieldForLandscapeImage()
        
        imageView.addSubview(topText)
        imageView.addSubview(bottomText)
        
        imageView.userInteractionEnabled = true
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, UIScreen.mainScreen().scale)
        
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
       
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
        
        toolbar.hidden = false
       
    
        // restore textfeild constraints
        restoreTextFieldsOriginalConstraint()
       
        return memedImage
    }
    
    // Save meme to shared meme array object
    func saveMemeImage(memeImage : UIImage) {
        
        //Create meme type
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imageView.image!, memeImage: memeImage)
       
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    // To move the textfield topText and bottomText down & up respectively 
    // So that it takes right place in meme that is landscape type
    func moveTextFieldForLandscapeImage(){
        
        let yOfImage = imageView.frame.origin.y
        
        let width = imageView.image?.size.width
        let height = imageView.image?.size.height
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        if width > height && orientation.isPortrait {
            topDistance.constant += (yOfImage + 50)
            bottomDistance.constant += (yOfImage + 50)
        }
    }
    
    // Restore the textfield constraints to original value
    func restoreTextFieldsOriginalConstraint() {
        topDistance.constant = 50
        bottomDistance.constant = 50
    }
}

