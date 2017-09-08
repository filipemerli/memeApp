//
//  ViewController.swift
//  SimpleMeme
//
//  Created by Filipe Merli on 18/08/17.
//  Copyright © 2017 Filipe Merli. All rights reserved.
//

import UIKit
import Foundation

// MARK: Main View Controller

class ViewController: UIViewController {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -4.0]
    
    func configure (textField: UITextField, withText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = withText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        resetAll()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        camButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    
    @IBAction func pickAnImageAlbum(_ sender:Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }

    @IBAction func pickAnImageCamera(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    
    func hideToolbars (toolbarTop:UIToolbar, toolbarBottom:UIToolbar, hideIt: Bool) {
        toolbarTop.isHidden = hideIt
        toolbarBottom.isHidden = hideIt
    }
    
    func generateMemeImage() -> UIImage {
        
        hideToolbars(toolbarTop: topToolbar, toolbarBottom: bottomToolbar, hideIt: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(toolbarTop: topToolbar, toolbarBottom: bottomToolbar, hideIt: false)
        //shareButton.isEnabled = false
        
        return memedImage
    }
    /*
    @IBAction func generateMeme(_ sender: Any) {

        let meme = Meme(memeTopText: topTextField.text, memeBottomText: bottomTextField.text, memeOriginalImage: imagePickerView.image, memeGeneratedImage: generateMemeImage())
        imagePickerView.image = meme.memeGeneratedImage
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [imagePickerView.image!], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if !success{
                print("cancelled")
                self.shareButton.isEnabled = true
                return
            }
            else if success{
                //let object = UIApplication.shared.delegate
                //let appDelegate = object as! AppDelegate
                //appDelegate.memes.append(meme)
                self.resetAll()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    */
    
    
    
    
    
    @IBAction func exportMeme(_ sender: AnyObject) {
        let image = generateMemeImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        self.present(controller, animated: true, completion: nil)
    }
    

    func save() {
        let meme = Meme(memeTopText: topTextField.text!, memeBottomText: bottomTextField.text!, memeOriginalImage: imagePickerView.image!, memeGeneratedImage: generateMemeImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    
    
    
    
    
    
    
    
    
    @IBAction func cacelMeme(_ sender: Any) {
        resetAll()
    }
    

    
    func resetAll() {
        configure(textField: bottomTextField, withText: "BOTTOM")
        configure(textField: topTextField, withText: "TOP")
        //shareButton.isEnabled = false
        imagePickerView.image = nil
    }
}


// MARK: Picker Controller

extension ViewController: UIImagePickerControllerDelegate {
    
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            //shareButton.isEnabled = true
        }
        //dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


// MARK: TextFields Delegate

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == topTextField {
            configure(textField: topTextField, withText: "")
        }
        else if textField == bottomTextField {
            configure(textField: bottomTextField, withText: "")
        }
        else {
            print("error")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: Keyboard functions

extension ViewController: UINavigationControllerDelegate {
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder == true {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder == true {
            view.frame.origin.y = 0
        }
    }
}


