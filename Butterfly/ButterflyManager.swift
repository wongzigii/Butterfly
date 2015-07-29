//
//  ButterflyManager.swift
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

public let ButterflyDidShakingNotification = "com.wongzigii.Butterfly.ShakingNotification"

private let instance = ButterflyManager()


///  Main manager class of Butterfly

public class ButterflyManager: NSObject, ButterflyViewControllerDelegate {
  
    public var imageWillUpload: UIImage? {
        return self.butterflyViewController?.imageWillUpload
    }
    
    public var textWillUpload: String? {
        return self.butterflyViewController?.textWillUpload
    }
    
    /// Manager is listening shake event or not.
    public var isListeningShake: Bool?
    
    /// Shared manager used by the extension across Butterfly.
    public class var sharedManager: ButterflyManager {
        return instance
    }
    
    /// ViewController instance used by this manager.
    var butterflyViewController: ButterflyViewController?
    
    /// Register and start listening shake event.
    /// Register this method in AppDelegate will listen all motions during the whole application's life cycle.
    public func startListeningShake() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "handleShake:",
            name: ButterflyDidShakingNotification,
            object: nil)
        isListeningShake = true
    }
    
    
    /// Unregister and stop listening shake event.
    /// Optional: you can just listen the specific one (viewController) you want.
    public func stopListeningShake() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: ButterflyDidShakingNotification,
            object: nil)
        isListeningShake = false
    }
    
    /// ButterflyViewController delegate method. Will be invoked when send button pressed. You may want to implement this method to handle the image.
    ///
    func ButterflyViewControllerDidPressedSendButton(drawView: ButterflyDrawView?) {
        /// NOTE: Custom this method for further uploading.
        ///
        /// That would be a great idea to upload your useful application information here manually .
        print("ButterflyViewController 's delegate method [-ButterflyViewControllerDidEndReporting] invoked\n")
    }
    
    /// Begin handling shake event.
    func handleShake(notification: NSNotification) {
        
        let screenshot = takeAScreenshot()
        
        butterflyViewController = ButterflyViewController()
        butterflyViewController?.delegate = self
        butterflyViewController?.image = screenshot
        
        var presented = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while let vc = presented?.presentedViewController {
            presented = presented?.presentedViewController
        }
        
        let nav = UINavigationController.init(rootViewController: butterflyViewController!)
        nav.modalTransitionStyle = .CrossDissolve
        
        if presented?.isKindOfClass(UINavigationController) == true {
            let rootvc: UIViewController = (presented as! UINavigationController).viewControllers[0] as! UIViewController
            if rootvc.isKindOfClass(ButterflyViewController) == false {
                presented?.presentViewController(nav, animated: true, completion: nil)
            }
        } else if presented?.isKindOfClass(ButterflyViewController) == false {
            presented?.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    
    //
    // MARK: - Take screenshot
    //
    // http://stackoverflow.com/questions/7964153/ios-whats-the-fastest-most-performant-way-to-make-a-screenshot-programaticall/8017292#8017292
    
    internal func takeAScreenshot() -> UIImage? {
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        let imageSize: CGSize = UIScreen.mainScreen().bounds.size
        let layer = UIApplication.sharedApplication().keyWindow?.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale);
        layer?.renderInContext(UIGraphicsGetCurrentContext())
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imageOrientation: UIImageOrientation
        switch orientation {
            case .LandscapeLeft:
                imageOrientation = UIImageOrientation.Left
                break
            case .LandscapeRight:
                imageOrientation = UIImageOrientation.Right
                break
            case .PortraitUpsideDown:
                imageOrientation = UIImageOrientation.Down
                break
            case .Unknown, .Portrait:
                imageOrientation = UIImageOrientation.Up
                break
        }
        let image = UIImage(CGImage: screenshot.CGImage, scale: screenshot.scale, orientation: imageOrientation)
        return image
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: ButterflyDidShakingNotification,
            object: nil)
    }
}
