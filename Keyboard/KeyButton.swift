//
//  KeyButton.swift
//  CustomKeyboard
//
//  Created by Brian Donohue on 6/5/14.
//  Copyright (c) 2014 Brian Donohue. All rights reserved.
//

import Foundation
import UIKit

class KeyButton: UIButton {
    override init(frame: CGRect)  {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22.0)
        self.titleLabel?.textAlignment = .Center
        self.setTitleColor(UIColor(white: 68.0/255, alpha: 1), forState: UIControlState.Normal)
        self.titleLabel?.sizeToFit()
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red: 216.0/255, green: 211.0/255, blue: 199.0/255, alpha: 1).CGColor
        self.layer.cornerRadius = 3
        
        self.backgroundColor = UIColor(red: 248.0/255, green: 242.0/255, blue: 227.0/255, alpha: 1)
        self.contentVerticalAlignment = .Center
        self.contentHorizontalAlignment = .Center
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}