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

struct Notification {
    static let ButterflyDidShakingNotification = "com.wongzigii.Butterfly.ShakingNotification"
}

private let instance = ButterflyManager()


///  Main manager class of Butterfly

open class ButterflyManager: NSObject {
    
    /// You can access instance variable `imageWillUpload` directly.
    open var imageWillUpload: UIImage? {
        return self.butterflyViewController?.imageWillUpload
    }
    
    /// Or instance variable `textWillUploader`.
    open var textWillUpload: String? {
        return self.butterflyViewController?.textWillUpload
    }
    
    /// Manager is listening shake event or not.
    open var isListeningShake: Bool?
    
    /// Shared manager used by the extension across Butterfly.
    open class var sharedManager: ButterflyManager {
        return instance
    }
    
    /// ViewController instance used by this manager.
    var butterflyViewController: ButterflyViewController?
    
    /// Register and start listening shake event.
    /// Register this method in AppDelegate will listen all motions during the whole application's life cycle.
    open func startListeningShake() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShake),
            name: NSNotification.Name(rawValue: Notification.ButterflyDidShakingNotification),
            object: nil)
        isListeningShake = true
    }
    
    
    /// Unregister and stop listening shake event.
    /// Optional: you can just listen the specific one (viewController) you want.
    open func stopListeningShake() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: Notification.ButterflyDidShakingNotification),
            object: nil)
        isListeningShake = false
    }
    
    /// Begin handling shake event.
    @objc func handleShake(_ notification: Foundation.Notification) {
        
        let screenshot = takeScreenshot()
        
        butterflyViewController = ButterflyViewController()
        butterflyViewController?.delegate = self
        butterflyViewController?.image = screenshot
        
        var presented = UIApplication.shared.keyWindow?.rootViewController
        
        while let vc = presented?.presentedViewController {
            presented = vc
        }
        
        let nav = UINavigationController.init(rootViewController: butterflyViewController!)
        nav.modalTransitionStyle = .crossDissolve
        
        if presented?.isKind(of: UINavigationController.self) == true {
            let rootvc: UIViewController = (presented as! UINavigationController).viewControllers[0] 
            if rootvc.isKind(of: ButterflyViewController.self) == false {
                presented?.present(nav, animated: true, completion: nil)
            }
        } else if presented?.isKind(of: ButterflyViewController.self) == false {
            presented?.present(nav, animated: true, completion: nil)
        }
    }
    
    fileprivate func currentDate() -> String! {
        let sec = Date().timeIntervalSinceNow
        let currentDate = Date(timeIntervalSinceNow: sec)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH/mm/ss"
        let string = dateFormatter.string(from: currentDate)
        return string
    }
    
    //
    // MARK: - Take screenshot
    //
    
    internal func takeScreenshot() -> UIImage? {
        
        let orientation = UIApplication.shared.statusBarOrientation
        let imageSize: CGSize = UIScreen.main.bounds.size
        let layer = UIApplication.shared.keyWindow?.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale);
        layer?.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imageOrientation: UIImageOrientation
        switch orientation {
        case .landscapeLeft:
            imageOrientation = UIImageOrientation.left
            break
        case .landscapeRight:
            imageOrientation = UIImageOrientation.right
            break
        case .portraitUpsideDown:
            imageOrientation = UIImageOrientation.down
            break
        case .unknown, .portrait:
            imageOrientation = UIImageOrientation.up
            break
        }
        let image = UIImage(cgImage: (screenshot?.cgImage!)!, scale: (screenshot?.scale)!, orientation: imageOrientation)
        return image
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: Notification.ButterflyDidShakingNotification),
            object: nil)
    }
}

extension ButterflyManager: ButterflyViewControllerDelegate {
    
    /// NOTE: Custom this method for further uploading.
    ///
    /// That would be a great idea to upload your useful application information here manually .
    
    func ButterflyViewControllerDidPressedSendButton(_ drawView: ButterflyDrawView?) {

        if let image = imageWillUpload {
            let data: UIImage = image
            ButterflyFileUploader.sharedUploader.addFileData( UIImageJPEGRepresentation(data,0.8)!, withName: currentDate(), withMimeType: "image/jpeg" )
        }
        
        ButterflyFileUploader.sharedUploader.upload()
        print("ButterflyViewController 's delegate method [-ButterflyViewControllerDidEndReporting] invoked\n")
    }
}
