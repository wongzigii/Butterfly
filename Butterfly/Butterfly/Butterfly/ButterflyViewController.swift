//
//  ButterflyViewController.swift
//  Butterfly
//
//  Created by Zhijie Huang on 15/6/20.
//
//  Copyright (c) 2015 Zhijie Huang <wongzigii@outlook.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

// MARK: - Protocol of `ButterflyViewController

@objc protocol ButterflyViewControllerDelegate {
    
    func ButterflyViewControllerDidEndReporting(drawView: ButterflyDrawView?)
}

// This is the viewController combined Butterfly modules.
class ButterflyViewController: UIViewController, ButterflyDrawViewDelegate, UITextViewDelegate {
    
    var topBar: ButterflyTopBar?
   
    var bottomBar: ButterflyBottomBar?
        
    var drawView: ButterflyDrawView?
    
    lazy var textView: ButterflyTextView = {
        let view = ButterflyTextView()
        return view
    }()
    
    weak var delegate: ButterflyViewControllerDelegate?
    
    var drawColor: UIColor?
    
    var drawLineWidth: Float?
    
    var imageView: UIImageView?
    
    var image: UIImage?
    
    var colors: [UIColor]?
    
    var textViewIsShowing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBarHidden = true
    }
    
    /// Set up the view
    private func setup() {
        
        imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
        imageView?.image = self.image
        imageView?.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin
        imageView?.contentMode = UIViewContentMode.Center
        self.view.addSubview(imageView!)
        
        drawView = ButterflyDrawView()
        drawView?.delegate = self
        self.view.addSubview(drawView!)
        
        topBar = ButterflyTopBar()
        self.view.addSubview(topBar!)
        
        bottomBar = ButterflyBottomBar()
        self.view.addSubview(bottomBar!)
        
        topBar?.sendButton?.addTarget(self, action: "sendButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        topBar?.cancelButton?.addTarget(self, action: "cancelButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar?.colorChangedButton?.addTarget(self, action: "colorChangedButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar?.descriptionButton?.addTarget(self, action: "inputDescriptionButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar?.clearPathButton?.addTarget(self, action: "clearButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        textView.delegate = self
        view.addSubview(self.textView)
    }

    func cancelButtonPressed(sender: UIButton?) {
        drawView?.enable()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func sendButtonPressed(sender: UIButton?) {
        drawView?.enable()
        delegate?.ButterflyViewControllerDidEndReporting(drawView)
        print("Send Button Pressed \n")
    }
    
    func colorChangedButtonPressed(sender: UIButton?) {
        drawView?.lineColor = UIColor.yellowColor()
    }
    
    func inputDescriptionButtonPressed(sender: UIButton?) {
        textView.show()
        drawView?.disable()
    }
    
    func clearButtonPressed(sender: UIButton?) {
        drawView?.clear()
    }
    
    
// MARK: - ButterflyDrawViewDelegate
    
    func drawViewDidEndDrawingInView(drawView: ButterflyDrawView?) {
        topBar?.show()
        bottomBar?.show()
    }
    
    func drawViewDidStartDrawingInView(drawView: ButterflyDrawView?) {
        topBar?.hide()
        bottomBar?.hide()
    }
    
// MARK: - UITextViewDelegate
    
/// Placeholder trick
    
/// Changed if statements to compare tags rather than text. If the user deleted their text it was possible to also 
/// accidentally delete a portion of the place holder. This meant if the user re-entered the textView the following
/// delegate method, `- textViewShouldBeginEditing` , it would not work as expected.

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.tag == 0 {
            textView.text = "";
            textView.textColor = UIColor.blackColor();
            textView.tag = 1;
        }
        return true;
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if count(textView.text) == 0 {
            textView.text = "Please enter your feedback."
            textView.textColor = UIColor.lightGrayColor()
            textView.tag = 0
        }
        if textView.isKindOfClass(ButterflyTextView) {
            self.textView.hide()
            self.drawView?.enable()
        }
    }
    
    /// Dismiss keyboard if `return` button pressed.
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
// MARK: - deinit
    
    deinit{
        drawView?.delegate = nil
    }
}
