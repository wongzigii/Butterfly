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

/// MARK: - Protocol of `ButterflyViewController

protocol ButterflyViewControllerDelegate: class {
    
    func ButterflyViewControllerDidPressedSendButton(drawView: ButterflyDrawView?)
}

/// This is the viewController combined Butterfly modules.
public class ButterflyViewController: UIViewController, ButterflyDrawViewDelegate, UITextViewDelegate {
    
    /// The image reported by users that will upload to server.
    internal var imageWillUpload: UIImage?
    
    /// The text reported by users that will upload to server.
    internal var textWillUpload: String?
    
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBarHidden = true
    }
    
    /// Set up the view
    private func setup() {
        
        imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
        imageView?.image = self.image
        imageView?.autoresizingMask = UIViewAutoresizing([.FlexibleWidth, .FlexibleHeight])
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

    public func cancelButtonPressed(sender: UIButton?) {
        drawView?.enable()
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    /// Note: Always access or upload `imageWillUpload` and `textWillUpload` only after send button has been pressed, otherwise, these two optional properties may be nil.
    /// After that, you can upload image and text manually and properly.
    public func sendButtonPressed(sender: UIButton?) {
        drawView?.enable()
        delegate?.ButterflyViewControllerDidPressedSendButton(drawView)
        imageWillUpload = ButterflyManager.sharedManager.takeAScreenshot()
        textWillUpload = textView.text
        
        if let textViewIsShowing = textView.isShowing {
            if textViewIsShowing == true {
                textView.hide()
            }
        }
        showAlertViewController()
        print(self.imageWillUpload)
        print(self.textWillUpload)
    }
    
    func showAlertViewController() {
        self.dismissViewControllerAnimated(false, completion: nil)
        let alert = UIAlertController(title: "Success", message: "Report Success", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentingViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    internal func colorChangedButtonPressed(sender: UIButton?) {
        if drawView?.lineColor != UIColor.yellowColor() {
            drawView?.lineColor = UIColor.yellowColor()
        } else {
            drawView?.lineColor = UIColor.redColor()
        }
    }
    
    internal func inputDescriptionButtonPressed(sender: UIButton?) {
        textView.show()
        drawView?.disable()
    }
    
    internal func clearButtonPressed(sender: UIButton?) {
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
    
    /// MARK: - UITextViewDelegate
    ///
    /// Placeholder trick
    ///
    /// Changed if statements to compare tags rather than text. If the user deleted their text it was possible to also
    /// accidentally delete a portion of the place holder. This meant if the user re-entered the textView the following
    /// delegate method, `- textViewShouldBeginEditing` , it would not work as expected.
    ///
    /// http://stackoverflow.com/questions/1328638/placeholder-in-uitextview/7091503#7091503
    /// DO NOT OVERRIDE THESE METHODS BELOW EXCEPTED YOU NEED INDEED.
    ///
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.tag == 0 {
            textView.text = "";
            textView.textColor = UIColor.blackColor();
            textView.tag = 1;
        }
        return true;
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        if textView.text.characters.count == 0 {
            textView.text = "Please enter your feedback."
            textView.textColor = UIColor.lightGrayColor()
            textView.tag = 0
        }
        
        self.textView.hide()
        drawView?.enable()
        textWillUpload = textView.text
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /// MARK: - deinit
    
    deinit{
        drawView?.delegate = nil
    }
}
