//
//  MemeEditorViewController.swift
//  MemeMe2.0
//
//  Created by EricTsui on 7/11/16.
//  Copyright © 2016 EricTsui. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    // MARK: - Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigatonBar: UINavigationBar!
    
    // MARK: - Variables and Constants
    
    let memeDelegate = memeTextFieldDelegate()
    enum ToolBarButtonItem: Int{
        case camera = 0
        case album  = 1
    }
    
    //To control cancel button display with 'cancelButton.isEnabled = isFromOtherViewController'
    //Initially, disable cancel button by assigning 'isFromOtherViewController' to false
    //Later, when it is presented from other View Controller, enable cancel button by assigning it to true
    var isFromOtherViewController = false
    
    //To hide status bar in Swift 3
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    
    //Pick an Image
    @IBAction func pickAnImage(_ sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        //Pick a new image from Camera or Album
        switch ToolBarButtonItem(rawValue: sender.tag)! {
        case .camera:
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
        case .album:
            pickerController.sourceType =
                UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(pickerController, animated: true, completion: nil)
    }
    
    //Share the Memed Image
    @IBAction func shareMemedImage(_ sender: AnyObject) {
        
        let latestMemedImage = generateMemedImage()
        
        // define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        let shareVC = UIActivityViewController(activityItems: [latestMemedImage], applicationActivities: nil)
        
        shareVC.completionWithItemsHandler = {
            (activityType, completed, returnedItem, error) in
            if completed {
                self.saveMeme(image: latestMemedImage)
                
                // present table/collection view
                let tabBarVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeTabBarViewController") as! UITabBarController
                //self.dismiss(animated: true, completion: nil)
                self.present(tabBarVC, animated: true, completion: nil)
            }
        }
        
        // present the ActivityViewController
        present(shareVC, animated: true, completion: nil)
    }
    
    //Exit the Meme
    @IBAction func cancelMeme(_ sender: AnyObject) {
        //dummy now for Meme 1.0
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Lifeycycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraBarButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        shareButton.isEnabled  = (imagePickerView.image != nil)
        //cancelButton.isEnabled = false
        cancelButton.isEnabled = isFromOtherViewController
        
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        //Set up TextField attributes and defaultText
        setupTextField(textField: topTextField, defaultText: "TOP")
        setupTextField(textField: buttomTextField, defaultText: "BOTTOM")
        
    }
    
    // MARK: - Private methods
    
    // MARK: Generate Memed Image and Save as Meme
    
    //Generate Memed Image, then return the memedImage
    private func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        navigatonBar.isHidden = true
        toolBar.isHidden = true
        
        //Render view to an image
        #if false
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let genMemedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            vvvv
        #endif
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let genMemedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        //Show toolbar and navbar
        navigatonBar.isHidden = false
        toolBar.isHidden = false
        
        //Return generated image
        return genMemedImage
    }
    
    
    //Save Meme, which is a struct that contains Memed Image and related meta data
    func saveMeme(image: UIImage){
        
        //Create the Meme struct instance
        let meme = Meme(topText: topTextField.text!, buttomText: buttomTextField.text!,
                        originImage: imagePickerView.image!, memedImage: image)
        //Append it to the Memes Array in the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // MARK: Util to setup Text Field
    //# TODO: - refine it
    

    
    struct MemeConstants {
        static var paragraphStyle = { () -> NSMutableParagraphStyle in
            var style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            return style
        }
        
        static let memeTextAttributtes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0,
        NSParagraphStyleAttributeName: paragraphStyle
        ] as [String : Any]
        
//        init(){
//            MemeConstants.paragraphStyle.alignment = .center
//        }
    
    }
    
    private func setupTextField(textField: UITextField, defaultText: String) {
        
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let memeTextAttributtes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
            NSParagraphStyleAttributeName: style
            ] as [String : Any]
        
        
        textField.defaultTextAttributes = memeTextAttributtes
        //need to put textAlignmnet after defaultTextAttributes assignment,otherwise the alignment will not make effect
        ///textField.textAlignment = .center
        textField.delegate = memeDelegate
        
        textField.text = defaultText
    }
    
    // MARK: Utils to move the view

    private func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        //Only the buttom Text Field needs to adjust the view
        if buttomTextField.isFirstResponder {
            //move the view when the keyboard covers the text field
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide() {
        //Move the view back when the keyboard is dismissed
        self.view.frame.origin.y = 0
    }
    
    private func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // MARK: - Delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Extensions
    
    }

