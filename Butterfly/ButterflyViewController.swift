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
    
    func ButterflyViewControllerDidPressedSendButton(_ drawView: ButterflyDrawView?)
}

/// This is the viewController combined Butterfly modules.
open class ButterflyViewController: UIViewController {
    
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
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.view.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// Set up the view
    fileprivate func setup() {
        
        imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView?.image = self.image
        imageView?.autoresizingMask = UIViewAutoresizing([.flexibleWidth, .flexibleHeight])
        imageView?.contentMode = UIViewContentMode.center
        self.view.addSubview(imageView!)
        
        drawView = ButterflyDrawView()
        drawView?.delegate = self
        self.view.addSubview(drawView!)
        
        topBar = ButterflyTopBar()
        self.view.addSubview(topBar!)
        
        bottomBar = ButterflyBottomBar()
        self.view.addSubview(bottomBar!)
        
        topBar?.sendButton?.addTarget(self, action: #selector(sendButtonPressed), for: UIControlEvents.touchUpInside)
        topBar?.cancelButton?.addTarget(self, action: #selector(cancelButtonPressed), for: UIControlEvents.touchUpInside)
        bottomBar?.colorChangedButton?.addTarget(self, action: #selector(colorChangedButtonPressed), for: UIControlEvents.touchUpInside)
        bottomBar?.descriptionButton?.addTarget(self, action: #selector(inputDescriptionButtonPressed), for: UIControlEvents.touchUpInside)
        bottomBar?.clearPathButton?.addTarget(self, action: #selector(clearButtonPressed), for: UIControlEvents.touchUpInside)
        
        textView.delegate = self
        view.addSubview(self.textView)
    }

    @objc open func cancelButtonPressed(_ sender: UIButton?) {
        drawView?.enable()
        dismiss(animated: false, completion: nil)
    }
    
    /// Note: Always access or upload `imageWillUpload` and `textWillUpload` only after send button has been pressed, otherwise, these two optional properties may be nil.
    /// After that, you can upload image and text manually and properly.
    @objc open func sendButtonPressed(_ sender: UIButton?) {
        drawView?.enable()
        delegate?.ButterflyViewControllerDidPressedSendButton(drawView)
        imageWillUpload = ButterflyManager.sharedManager.takeScreenshot()
        textWillUpload = textView.text
        
        if let textViewIsShowing = textView.isShowing {
            if textViewIsShowing == true {
                textView.hide()
            }
        }
        showAlertViewController()
        print(self.imageWillUpload!)
        print(self.textWillUpload!)
    }
    
    func showAlertViewController() {
        self.dismiss(animated: false, completion: nil)
        let alert = UIAlertController(title: "Success", message: "Report Success", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.presentingViewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc internal func colorChangedButtonPressed(_ sender: UIButton?) {
        if drawView?.lineColor != UIColor.yellow {
            drawView?.lineColor = UIColor.yellow
        } else {
            drawView?.lineColor = UIColor.red
        }
    }
    
    @objc internal func inputDescriptionButtonPressed(_ sender: UIButton?) {
        textView.show()
        drawView?.disable()
    }
    
    @objc internal func clearButtonPressed(_ sender: UIButton?) {
        drawView?.clear()
    }
    
    /// MARK: - deinit
    
    deinit{
        drawView?.delegate = nil
    }
}

extension ButterflyViewController: ButterflyDrawViewDelegate {

    func drawViewDidEndDrawingInView(_ drawView: ButterflyDrawView?) {
        topBar?.show()
        bottomBar?.show()
    }
    
    func drawViewDidStartDrawingInView(_ drawView: ButterflyDrawView?) {
        topBar?.hide()
        bottomBar?.hide()
    }
}

extension ButterflyViewController: UITextViewDelegate {

    /// Placeholder trick
    ///
    /// Changed if statements to compare tags rather than text. If the user deleted their text it was possible to also
    /// accidentally delete a portion of the place holder. This meant if the user re-entered the textView the following
    /// delegate method, `- textViewShouldBeginEditing` , it would not work as expected.
    ///
    /// http://stackoverflow.com/questions/1328638/placeholder-in-uitextview/7091503#7091503
    /// DO NOT OVERRIDE THESE METHODS BELOW EXCEPTED YOU NEED INDEED.
    ///
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.tag == 0 {
            textView.text = "";
            textView.textColor = UIColor.black;
            textView.tag = 1;
        }
        return true;
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "Please enter your feedback."
            textView.textColor = UIColor.lightGray
            textView.tag = 0
        }
        
        self.textView.hide()
        drawView?.enable()
        textWillUpload = textView.text
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
