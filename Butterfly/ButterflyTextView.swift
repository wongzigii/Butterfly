//
//  ButterflyTextView.swift
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

private struct TextView {
    static let CornerRadius: CGFloat = 10
    static let WidthMargin: CGFloat = 10
    static let Height = UIScreen.main.bounds.size.height / 5
}

internal class ButterflyTextView : UITextView {
    
    var isShowing: Bool!
    
    init() {
        let frame = CGRect(
            x: TextView.WidthMargin,
            y: -TextView.Height,
            width: UIScreen.main.bounds.size.width - 2 * TextView.WidthMargin,
            height: TextView.Height)
        super.init(frame: frame, textContainer: nil)
        layer.cornerRadius = TextView.CornerRadius
        clipsToBounds = true
        isShowing = false
    }
    
    required init(coder aDecode : NSCoder) {
        fatalError("init(coder:) has not been implemented\n")
    }
    
    func show() {
        if isShowing == false {
            isShowing = true
            UIView.animate(withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.7,
                options: UIViewAnimationOptions(),
                animations: { () -> Void in
                    self.frame = CGRect(
                        x: self.frame.origin.x,
                        y: -self.frame.origin.y,
                        width: self.frame.size.width,
                        height: self.frame.size.height)
                }) { (Bool) -> Void in
                    self.becomeFirstResponder()
            }
        }
    }
    
    func hide() {
        if isShowing == true {
            isShowing = false
            UIView.animate(withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.7,
                options: UIViewAnimationOptions(),
                animations: { () -> Void in
                    self.frame = CGRect(
                        x: self.frame.origin.x,
                        y: -self.frame.origin.y,
                        width: self.frame.size.width,
                        height: self.frame.size.height)
                }) { (Bool) -> Void in
                    self.resignFirstResponder()
            }
        }
    }
}
