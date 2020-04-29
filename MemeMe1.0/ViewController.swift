//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Patrick Groß on 29.04.20.
//  Copyright © 2020 Patrick Groß. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		shareButton.isEnabled = false
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		//MARK: Set Text Attributes
		topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
		topTextField.defaultTextAttributes = memeTextAttributes
		topTextField.textAlignment = .center
		topTextField.delegate = self
		
		bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.textAlignment = .center
		bottomTextField.delegate = self
	}
	
	//MARK: ACTIONS
	@IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
		let image = [generateMemedImage()]
		let ac = UIActivityViewController(activityItems: image, applicationActivities: nil)
		present(ac, animated: true)
	}
	
	@IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
		topTextField.text = "TOP"
		bottomTextField.text = "BOTTOM"
		shareButton.isEnabled = false
		memeImageView.image = nil
	}
	
	@IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.mediaTypes = ["public.image"]
		imagePicker.sourceType = .camera
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func albumButtonPressed(_ sender: UIBarButtonItem) {
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.mediaTypes = ["public.image"]
		imagePicker.sourceType = .photoLibrary
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	//MARK: TextField Actions
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.placeholder = ""
		
		if textField == bottomTextField {
			subscribeToKeyboardNotifications()
		}
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
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		toolbarBottom.isHidden = false
		toolbarTop.isHidden = false
		return memedImage
	}
}

