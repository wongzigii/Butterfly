//
//  ButterflyBottomBar.swift
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

private let bottomBarHeight: CGFloat = 44
private let bottomBarButtonSize: CGFloat = 25
private let ButtonMarginWidth: CGFloat = 10
private let barViewBackgroundColor: UIColor = UIColor(red: 46 / 255, green: 45 / 255, blue: 45 / 255, alpha: 1.0)

class ButterflyBottomBar: UIView {
    
    var colorChangedButton: UIButton?
    var descriptionButton: UIButton?
    var clearPathButton: UIButton?
    
    convenience init() {
        self.init(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - bottomBarHeight, UIScreen.mainScreen().bounds.width, bottomBarHeight))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented\n")
    }
    
    private func setup() {
        self.backgroundColor = barViewBackgroundColor
        
        let centerY: CGFloat = self.frame.size.height / 2 - bottomBarButtonSize / 2
        
        ///3.
        let colorChangeButtonImg = UIImage(named: "analytics.png")
        //let colorChangeButtonImg = UIImage(named: "analytics.png", inBundle: NSBundle(forClass: ButterflyBottomBar.self), compatibleWithTraitCollection: nil)
        //let descriptionButtonImg = UIImage(named: "email-outline.png", inBundle: NSBundle(forClass: ButterflyBottomBar.self), compatibleWithTraitCollection: nil)
        
        ////2.
        let clearButtonImg = UIImage(named: "trash.png", inBundle: NSBundle(forClass: ButterflyBottomBar.self), compatibleWithTraitCollection: nil)
        
        ////1.
        let string = NSString(format: "%@/Butterfly.framework/Logo/email-outline.png", NSBundle.mainBundle().bundlePath)
        let image = UIImage(contentsOfFile: string as String)
        
        colorChangedButton = UIButton()
        colorChangedButton?.frame = CGRectMake(ButtonMarginWidth, centerY, bottomBarButtonSize, bottomBarButtonSize)
        colorChangedButton?.setImage(colorChangeButtonImg, forState: UIControlState.Normal)
        self.addSubview(colorChangedButton!)
        
        descriptionButton = UIButton()
        descriptionButton?.frame = CGRectMake(self.center.x - bottomBarButtonSize / 2, centerY, bottomBarButtonSize, bottomBarButtonSize)
        descriptionButton?.setImage(image, forState: UIControlState.Normal)
        self.addSubview(descriptionButton!)
        
        clearPathButton = UIButton()
        clearPathButton?.frame = CGRectMake(self.frame.size.width - ButtonMarginWidth - bottomBarButtonSize, centerY, bottomBarButtonSize, bottomBarButtonSize)
        clearPathButton?.setImage(clearButtonImg, forState: UIControlState.Normal)
        self.addSubview(clearPathButton!)
    }
    
    func hide() {
        self.hidden = true
    }
    
    func show() {
        self.hidden = false
    }
}
