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

private struct BottomBar {
    static let Height: CGFloat = 44
    static let ButtonSize: CGFloat = 25
    static let ButtonMarginWidth: CGFloat = 10
    static let BackgroundColor: UIColor = UIColor(red: 46 / 255, green: 45 / 255, blue: 45 / 255, alpha: 1.0)
}

class ButterflyBottomBar: UIView {
    
    var colorChangedButton: UIButton?
    var descriptionButton: UIButton?
    var clearPathButton: UIButton?
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - BottomBar.Height, width: UIScreen.main.bounds.width, height: BottomBar.Height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented\n")
    }
    
    fileprivate func setup() {
        self.backgroundColor = BottomBar.BackgroundColor
        
        let centerY: CGFloat = self.frame.size.height / 2 - BottomBar.ButtonSize / 2
        
        let bundlePath = NSString(format: "%@/Frameworks/Butterfly.framework/Butterfly.bundle", Bundle.main.bundlePath)
        let colorChangeButtonImgPath = NSString(format: "%@/analytics.png", bundlePath)
        let colorChangeButtonImg = UIImage(contentsOfFile: colorChangeButtonImgPath as String)
        let descriptionButtonImgPath = NSString(format: "%@/email-outline.png", bundlePath)
        let descriptionButtonImg = UIImage(contentsOfFile: descriptionButtonImgPath as String)
        let clearButtonImgPath = NSString(format: "%@/trash.png", bundlePath)
        let clearButtonImg = UIImage(contentsOfFile: clearButtonImgPath as String)
        
        colorChangedButton = UIButton()
        let colorButtonRect = CGRect(
            x: BottomBar.ButtonMarginWidth,
            y: centerY,
            width: BottomBar.ButtonSize,
            height: BottomBar.ButtonSize)
        colorChangedButton?.frame = colorButtonRect
        colorChangedButton?.setImage(colorChangeButtonImg, for: UIControlState())
        self.addSubview(colorChangedButton!)
        
        descriptionButton = UIButton()
        let descriptionButtonRect = CGRect(
            x: self.center.x - BottomBar.ButtonSize / 2,
            y: centerY,
            width: BottomBar.ButtonSize,
            height: BottomBar.ButtonSize)
        descriptionButton?.frame = descriptionButtonRect
        descriptionButton?.setImage(descriptionButtonImg, for: UIControlState())
        self.addSubview(descriptionButton!)
        
        clearPathButton = UIButton()
        let clearPathButtonRect = CGRect(
            x: self.frame.size.width - BottomBar.ButtonMarginWidth - BottomBar.ButtonSize,
            y: centerY,
            width: BottomBar.ButtonSize,
            height: BottomBar.ButtonSize)
        clearPathButton?.frame = clearPathButtonRect
        clearPathButton?.setImage(clearButtonImg, for: UIControlState())
        self.addSubview(clearPathButton!)
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
}
