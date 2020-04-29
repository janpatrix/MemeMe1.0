//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Patrick Groß on 29.04.20.
//  Copyright © 2020 Patrick Groß. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var toolbarTop: UIToolbar!
	@IBOutlet weak var toolbarBottom: UIToolbar!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	
	@IBOutlet weak var memeImageView: UIImageView!
	@IBOutlet weak var albumButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	//MARK: ACTIONS
	@IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
	}
	
	@IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
	}
	
	@IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
	}
	
	@IBAction func albumButtonPressed(_ sender: UIBarButtonItem) {
	}
	
}

