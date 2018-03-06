//
//  ButterflyTopBar.swift
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

private struct TopBar {
    static let Height: CGFloat = 75 * (UIScreen.main.bounds.height / 667.0)
    static let MarginWidth: CGFloat = 10
    static let ButtonWidth: CGFloat = 80
    static let ButtonHeight: CGFloat = 30
    static let ButtonBackgroundColor = UIColor(red: 56 / 255, green: 55 / 255, blue: 55 / 255, alpha: 1.0)
    static let BarViewBackgroundColor = UIColor(red: 46 / 255, green: 45 / 255, blue: 45 / 255, alpha: 1.0)
    static let ButtonPressedBackgroundColor = UIColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1.0)
}

internal class ButterflyTopBar: UIView {
    
    var sendButton: UIButton?
    var cancelButton: UIButton?
    var titleLabel: UILabel?
    
    convenience init() {
        let rect = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.size.width,
            height: TopBar.Height)
        self.init(frame: rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        backgroundColor = TopBar.BarViewBackgroundColor
        
        let centerY: CGFloat = self.frame.size.height / 2 - TopBar.ButtonHeight / 2
        
        cancelButton = UIButton()
        cancelButton?.frame = CGRect(
            x: TopBar.MarginWidth,
            y: centerY,
            width: TopBar.ButtonWidth,
            height: TopBar.ButtonHeight)
        cancelButton?.setTitle("Cancel", for: UIControlState())
        cancelButton?.titleLabel?.textAlignment = NSTextAlignment.center
        cancelButton?.titleLabel?.textColor = UIColor.white
        cancelButton?.layer.cornerRadius = 5
        cancelButton?.clipsToBounds = true
        cancelButton?.backgroundColor = UIColor.clear
        cancelButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(cancelButton!)
        
        titleLabel = UILabel()
        titleLabel?.frame = CGRect(
            x: self.frame.width / 2 - TopBar.ButtonWidth / 2,
            y: centerY,
            width: TopBar.ButtonWidth,
            height: TopBar.ButtonHeight)
        titleLabel?.text = "Feedback"
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.addSubview(titleLabel!)
        
        sendButton = UIButton()
        sendButton?.frame = CGRect(
            x: self.frame.size.width - TopBar.MarginWidth - TopBar.ButtonWidth,
            y: centerY,
            width: TopBar.ButtonWidth,
            height: TopBar.ButtonHeight)
        sendButton?.setTitle("Send", for: UIControlState())
        sendButton?.titleLabel?.textAlignment = NSTextAlignment.center
        sendButton?.titleLabel?.textColor = UIColor.white
        sendButton?.backgroundColor = UIColor.clear
        sendButton?.layer.cornerRadius = 5
        sendButton?.clipsToBounds = true
        sendButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(sendButton!)
    }
    
    fileprivate func generateImageFromUIColor(_ color: UIColor?) -> UIImage! {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color!.cgColor)
        context?.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    fileprivate func setupHighlightedImageForButton() {
        let highlightedImage: UIImage = generateImageFromUIColor(TopBar.ButtonPressedBackgroundColor)
        let normalImage: UIImage = generateImageFromUIColor(TopBar.ButtonBackgroundColor)
        cancelButton?.setBackgroundImage(highlightedImage, for: UIControlState.highlighted)
        sendButton?.setBackgroundImage(highlightedImage, for: UIControlState.highlighted)
        cancelButton?.setBackgroundImage(normalImage, for: UIControlState())
        sendButton?.setBackgroundImage(normalImage, for: UIControlState())
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
}
