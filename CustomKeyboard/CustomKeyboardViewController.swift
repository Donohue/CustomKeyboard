//
//  CustomKeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Brian Donohue on 6/5/14.
//  Copyright (c) 2014 Brian Donohue. All rights reserved.
//

import Foundation
import UIKit

class CustomKeyboardViewController: UIViewController {
    var textView: UITextView?
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().applicationFrame)
        self.textView = UITextView(frame: CGRect(x: 0.0, y: 20.0,
                                                 width: self.view.frame.size.width,
                                                 height: self.view.frame.size.height))
        self.view.addSubview(self.textView!)
    }
    
    override func viewDidLoad() {
        self.textView!.becomeFirstResponder()
    }
}
