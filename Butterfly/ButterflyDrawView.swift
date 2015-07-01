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

@objc protocol ButterflyDrawViewDelegate {
    ///
    /// Called when start drawing in ButterflyDrawView
    ///
    func drawViewDidStartDrawingInView(drawView: ButterflyDrawView?)
    
    ///
    /// Called when end drawing in ButterflyDrawView
    ///
    func drawViewDidEndDrawingInView(drawView: ButterflyDrawView?)
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
    
    private var backgroundImageView: UIImageView?
    
    private var path: UIBezierPath?
    
    private var previousPoint: CGPoint?
    
    private var oldPoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.mainScreen().bounds)
        lineWidth = 3.0
        lineColor = UIColor.redColor()
        setup()
    }
    
    // Use this initializer to custom lineWidth and lineColor if need.
    
    convenience init(lineWidth: Float, lineColor: UIColor) {
        self.init(frame: UIScreen.mainScreen().bounds)
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented\n")
    }
    
    private func setup() {
        backgroundColor = UIColor.clearColor()
        
        backgroundImageView = UIImageView(frame: self.bounds)
        addSubview(backgroundImageView!)
        backgroundImageView?.autoresizingMask = UIViewAutoresizing.FlexibleHeight | .FlexibleWidth
        backgroundImageView?.contentMode = UIViewContentMode.Center
        
        path = UIBezierPath()
        if let lineWidth = self.lineWidth {
            path?.lineWidth = CGFloat(self.lineWidth!)
        }
        path?.lineCapStyle = kCGLineCapRound
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        isTouchBegan = true
        breakOutPath()
        if let touch = touches.first as? UITouch {
            previousPoint = touch.locationInView(self)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let bool = isTouchBegan {
            if let delegate = self.delegate  {
                delegate.drawViewDidStartDrawingInView(self)
            }
            isTouchBegan = false
        }
        
        if let touch = touches.first as? UITouch {
            oldPoint = previousPoint
            previousPoint = touch.previousLocationInView(self)
            let currentPoint: CGPoint = touch.locationInView(self)
            
            let midPoint1 = CGPointMake((oldPoint!.x + previousPoint!.x) / 2, (oldPoint!.y + previousPoint!.y) / 2)
            let midPoint2 = CGPointMake((previousPoint!.x + currentPoint.x) / 2, (previousPoint!.y + currentPoint.y) / 2)
            
            path?.moveToPoint(midPoint1)
            path?.addQuadCurveToPoint(midPoint2, controlPoint: previousPoint!)
            
            setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
        cache()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        cache()
        if let delegate = self.delegate {
            delegate.drawViewDidEndDrawingInView(self)
        }
    }
    
    /// Cache for the current image.
    
    private func cache() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        layer.renderInContext(UIGraphicsGetCurrentContext())
        backgroundImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetAllowsAntialiasing(context, true)
        CGContextSetShouldAntialias(context, true)
        
        lineColor?.setStroke()
        path?.stroke()
    }
    
    private func breakOutPath() {
        path?.removeAllPoints()
    }
    
    func clear() {
        breakOutPath()
        backgroundImageView?.image = nil
        setNeedsDisplay()
    }
    
    func disable() {
        self.userInteractionEnabled = false
    }
    
    func enable() {
        self.userInteractionEnabled = true
    }
    
    deinit {
        self.delegate = nil
    }
}
