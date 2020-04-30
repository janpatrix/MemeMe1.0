//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Patrick Groß on 29.04.20.
//  Copyright © 2020 Patrick Groß. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var toolbarTop: UIToolbar!
	@IBOutlet weak var toolbarBottom: UIToolbar!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var albumButton: UIBarButtonItem!

	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	
	@IBOutlet weak var memeImageView: UIImageView!
	
	let imagePicker = UIImagePickerController()
	
	let memeTextAttributes: [NSAttributedString.Key: Any] = [
		NSAttributedString.Key.strokeColor: UIColor.black,
		NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSAttributedString.Key.strokeWidth:  -4.5
	]
	
	let defaultTopText = "ENTER TOP TEXT"
	let defaultBottomText = "ENTER BOTTOM TEXT"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		shareButton.isEnabled = false
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		//MARK: Set Text Attributes
		setMemeText(textField: topTextField, defaultText: defaultTopText)
		setMemeText(textField: bottomTextField, defaultText: defaultBottomText)
	}
	
	//MARK: ACTIONS
	@IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
		let origImage = memeImageView.image
		let memedImage = [generateMemedImage()]
		let ac = UIActivityViewController(activityItems: memedImage, applicationActivities: nil)
		ac.completionWithItemsHandler = { [weak self] type, completed, items, error in
			
			
			if completed {
				let meme = Meme(topText: self!.topTextField.text!, bottomText: self!.bottomTextField.text!, origImage: origImage!, memedImage: memedImage)
		    }
			
			ac.dismiss(animated: true, completion: nil)
		}
		
		present(ac, animated: true)
	}
	
	@IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
		topTextField.text = defaultTopText
		bottomTextField.text = defaultBottomText
		shareButton.isEnabled = false
		memeImageView.image = nil
	}
	
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
        imagePicker.delegate = self;
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
	
	@IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
		endTextFieldEditing()
		pickFromSource(.camera)
	}
	
	@IBAction func albumButtonPressed(_ sender: UIBarButtonItem) {
		endTextFieldEditing()
		pickFromSource(.photoLibrary)
	}
	
	//MARK: TextField Actions
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text = ""
		
		if textField == bottomTextField {
			subscribeToKeyboardNotifications()
		}
	}
	
	func endTextFieldEditing(){
		bottomTextField.endEditing(true)
		topTextField.endEditing(true)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == bottomTextField {
			unsubscribeFromKeyboardNotifications()
		}
	}
		
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		view.frame.origin.y = -getKeyboardHeight(notification)
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
	
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	//MARK: ImagePicker Actions
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			
			memeImageView.contentMode = .scaleAspectFill
		    memeImageView.image = pickedImage
			shareButton.isEnabled = true
		}
		
		   dismiss(animated: true, completion: nil)
	}
	
	//MARK: Generate Memed Image
	func generateMemedImage() -> UIImage {

		toolbarBottom.isHidden = true
		toolbarTop.isHidden = true

		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		toolbarBottom.isHidden = false
		toolbarTop.isHidden = false
		return memedImage
	}
	
	func setMemeText(textField: UITextField, defaultText: String){
		
		textField.text = defaultText
		textField.defaultTextAttributes = memeTextAttributes
		textField.textAlignment = .center
		textField.delegate = self
	}
}

