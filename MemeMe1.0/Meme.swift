//
//  Meme.swift
//  MemeMe1.0
//
//  Created by Patrick Groß on 30.04.20.
//  Copyright © 2020 Patrick Groß. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
	var topText: String!
	var bottomText: String!
	var origImage: UIImage!
	var memedImage: [UIImage]
	
	init(topText: String, bottomText: String, origImage: UIImage, memedImage: [UIImage]) {
		self.topText = topText
		self.bottomText = bottomText
		self.origImage = origImage
		self.memedImage = memedImage
	}
}
