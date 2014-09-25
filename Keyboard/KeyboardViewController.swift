//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Brian Donohue on 6/5/14.
//  Copyright (c) 2014 Brian Donohue. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    let rows = [["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                ["z", "x", "c", "v", "b", "n", "m"]]
    let topPadding: CGFloat = 12
    let keyHeight: CGFloat = 40
    let keyWidth: CGFloat = 26
    let keySpacing: CGFloat = 6
    let rowSpacing: CGFloat = 15
    let shiftWidth: CGFloat = 40
    let shiftHeight: CGFloat = 40
    let spaceWidth: CGFloat = 210
    let spaceHeight: CGFloat = 40
    let nextWidth: CGFloat = 50
    
    var buttons: Array<UIButton> = []
    var shiftKey: UIButton?
    var deleteKey: UIButton?
    var spaceKey: UIButton?
    var nextKeyboardButton: KeyButton?
    var returnButton: KeyButton?
    
    var shiftPosArr = [0]
    var numCharacters = 0
    var spacePressed = false
    var spaceTimer: NSTimer?
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor(red: 241.0/255, green: 235.0/255, blue: 221.0/255, alpha: 1)

        let border = UIView(frame: CGRect(x:CGFloat(0.0), y:CGFloat(0.0), width:self.view.frame.size.width, height:CGFloat(0.5)))
        border.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        border.backgroundColor = UIColor(red: 210.0/255, green: 205.0/255, blue: 193.0/255, alpha: 1)
        self.view.addSubview(border)
        
        var thirdRowTopPadding: CGFloat = topPadding + (keyHeight + rowSpacing) * 2
        shiftKey = KeyButton(frame: CGRect(x: 2.0, y: thirdRowTopPadding, width:shiftWidth, height:shiftHeight))
        shiftKey!.addTarget(self, action: Selector("shiftKeyPressed:"), forControlEvents: .TouchUpInside)
        shiftKey!.selected = true
        shiftKey!.setImage(UIImage(named: "shift.png"), forState:.Normal)
        shiftKey!.setImage(UIImage(named: "shift-selected.png"), forState:.Selected)
        self.view.addSubview(shiftKey!)
        
        deleteKey = KeyButton(frame: CGRect(x:320 - shiftWidth - 2.0, y: thirdRowTopPadding, width:shiftWidth, height:shiftHeight))
        deleteKey!.addTarget(self, action: Selector("deleteKeyPressed:"), forControlEvents: .TouchUpInside)
        deleteKey!.setImage(UIImage(named: "delete.png"), forState:.Normal)
        deleteKey!.setImage(UIImage(named: "delete-selected.png"), forState:.Highlighted)
        self.view.addSubview(deleteKey!)
        
        var bottomRowTopPadding = topPadding + keyHeight * 3 + rowSpacing * 2 + 10
        spaceKey = KeyButton(frame: CGRect(x:(320.0 - spaceWidth) / 2, y: bottomRowTopPadding, width:spaceWidth, height:spaceHeight))
        spaceKey!.setTitle(" ", forState: .Normal)
        spaceKey!.addTarget(self, action: Selector("keyPressed:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(spaceKey!)
        
        nextKeyboardButton = KeyButton(frame:CGRect(x:2, y: bottomRowTopPadding, width:nextWidth, height:spaceHeight))
        nextKeyboardButton!.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size:18)
        nextKeyboardButton!.setTitle(NSLocalizedString("Next", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        nextKeyboardButton!.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        view.addSubview(self.nextKeyboardButton!)
        
        returnButton = KeyButton(frame: CGRect(x:320 - nextWidth - 2, y: bottomRowTopPadding, width:nextWidth, height:spaceHeight))
        returnButton!.setTitle(NSLocalizedString("Ret", comment: "Title for 'Return Key' button"), forState:.Normal)
        returnButton!.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size:18)
        returnButton!.addTarget(self, action: "returnKeyPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(returnButton!)
        
        var y: CGFloat = topPadding
        var width = UIScreen.mainScreen().applicationFrame.size.width
        for row in rows {
            var x: CGFloat = ceil((width - (CGFloat(row.count) - 1) * (keySpacing + keyWidth) - keyWidth) / 2.0)
            for label in row {
                let button = KeyButton(frame: CGRect(x: x, y: y, width: keyWidth, height: keyHeight))
                button.setTitle(label.uppercaseString, forState: .Normal)
                button.addTarget(self, action: Selector("keyPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
                //button.autoresizingMask = .FlexibleWidth | .FlexibleLeftMargin | .FlexibleRightMargin
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
                
                self.view.addSubview(button)
                buttons.append(button)
                x += keyWidth + keySpacing
            }
            
            y += keyHeight + rowSpacing
        }
    }
    
    func returnKeyPressed(sender: UIButton) {
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText("\n")
        numCharacters++
        shiftPosArr[shiftPosArr.count - 1]++
        if shiftKey!.selected {
            shiftPosArr.append(0)
            setShiftValue(true)
        }
        
        spacePressed = false
    }
    
    func deleteKeyPressed(sender: UIButton) {
        if numCharacters > 0 {
            var proxy = self.textDocumentProxy as UITextDocumentProxy
            proxy.deleteBackward()
            numCharacters--
            var charactersSinceShift = shiftPosArr[shiftPosArr.count - 1]
            if charactersSinceShift > 0 {
                charactersSinceShift--
            }
            
            setShiftValue(charactersSinceShift == 0)
            if charactersSinceShift == 0 && shiftPosArr.count > 1 {
                shiftPosArr.removeLast()
            }
            else {
                shiftPosArr[shiftPosArr.count - 1] = charactersSinceShift
            }
        }
        
        spacePressed = false
    }
    
    func shiftKeyPressed(sender: UIButton) {
        setShiftValue(!shiftKey!.selected)
        if shiftKey!.selected {
            shiftPosArr.append(0)
        }
        else if shiftPosArr[shiftPosArr.count - 1] == 0 {
            shiftPosArr.removeLast()
        }
        
        spacePressed = false
    }
    
    func keyPressed(sender: UIButton) {
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if spacePressed && sender.titleLabel?.text == " " {
            proxy.deleteBackward()
            proxy.insertText(". ")
            spacePressed = false
        }
        else {
            proxy.insertText(sender.titleLabel?.text ?? "")
            spacePressed = sender.titleLabel?.text == " "
            if spacePressed {
                spaceTimer?.invalidate()
                spaceTimer = NSTimer.scheduledTimerWithTimeInterval(1,
                                    target: self,
                                  selector: Selector("spaceTimeout"),
                                  userInfo: nil,
                                   repeats: false)
            }
        }
        
        numCharacters++
        shiftPosArr[shiftPosArr.count - 1]++
        if (shiftKey!.selected) {
            self.setShiftValue(false)
        }
    }
    
    func spaceTimeout() {
        spaceTimer = nil
        spacePressed = false
    }
    
    func setShiftValue(shiftVal: Bool) {
        if shiftKey?.selected != shiftVal {
            shiftKey!.selected = shiftVal
            for button in buttons {
                var text = button.titleLabel?.text
                if shiftKey!.selected {
                    text = text?.uppercaseString
                } else {
                    text = text?.lowercaseString
                }
                
                button.setTitle(text, forState: UIControlState.Normal)
                button.titleLabel?.sizeToFit()
            }
        }
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        //self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
