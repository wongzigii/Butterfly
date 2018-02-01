//
//  ButterflyDrawView.swift
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
import CoreGraphics

///
//	Protocol of `ButterflyDrawView`.
//

protocol ButterflyDrawViewDelegate: class {
    ///
    /// Called when start drawing in ButterflyDrawView
    ///
    func drawViewDidStartDrawingInView(_ drawView: ButterflyDrawView?)
    
    ///
    /// Called when end drawing in ButterflyDrawView
    ///
    func drawViewDidEndDrawingInView(_ drawView: ButterflyDrawView?)
}

///
// ButterflyDrawView Class.
//
internal class ButterflyDrawView : UIView {
    
    /// Line width of the drawing path.
    var lineWidth: Float?
    
    /// Line color of the drawing path.
    var lineColor: UIColor?
    
    weak var delegate: ButterflyDrawViewDelegate?
    
    var isTouchBegan: Bool?
    
    fileprivate var backgroundImageView: UIImageView?
    
    fileprivate var path: UIBezierPath?
    
    fileprivate var previousPoint: CGPoint?
    
    fileprivate var oldPoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        lineWidth = 3.0
        lineColor = UIColor.red
        setup()
    }
    
    // Use this initializer to custom lineWidth and lineColor if need.
    
    convenience init(lineWidth: Float, lineColor: UIColor) {
        self.init(frame: UIScreen.main.bounds)
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented\n")
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        
        backgroundImageView = UIImageView(frame: self.bounds)
        addSubview(backgroundImageView!)
        backgroundImageView?.autoresizingMask = UIViewAutoresizing([.flexibleHeight, .flexibleWidth])
        backgroundImageView?.contentMode = UIViewContentMode.center
        
        path = UIBezierPath()
        if let lineWidth = self.lineWidth {
            path?.lineWidth = CGFloat(lineWidth)
        }
        path?.lineCapStyle = CGLineCap.round
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchBegan = true
        breakOutPath()
        if let touch = touches.first {
            previousPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let delegate = self.delegate {
            delegate.drawViewDidStartDrawingInView(self)
            isTouchBegan = false
        }
        
        if let touch = touches.first {
            oldPoint = previousPoint
            previousPoint = touch.previousLocation(in: self)
            let currentPoint: CGPoint = touch.location(in: self)
            
            let midPoint1 = CGPoint(
                x: (oldPoint!.x + previousPoint!.x) / 2,
                y: (oldPoint!.y + previousPoint!.y) / 2)
            let midPoint2 = CGPoint(
                x: (previousPoint!.x + currentPoint.x) / 2,
                y: (previousPoint!.y + currentPoint.y) / 2)
            
            path?.move(to: midPoint1)
            path?.addQuadCurve(to: midPoint2, controlPoint: previousPoint!)
            
            setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        cache()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cache()
        if let delegate = self.delegate {
            delegate.drawViewDidEndDrawingInView(self)
        }
    }
    
    /// Cache for the current image.
    
    fileprivate func cache() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        backgroundImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        
        lineColor?.setStroke()
        path?.stroke()
    }
    
    fileprivate func breakOutPath() {
        path?.removeAllPoints()
    }
    
    func clear() {
        breakOutPath()
        backgroundImageView?.image = nil
        setNeedsDisplay()
    }
    
    func disable() {
        self.isUserInteractionEnabled = false
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
    }
    
    deinit {
        self.delegate = nil
    }
}
