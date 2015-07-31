# Butterfly

![language](https://img.shields.io/badge/Language-%20Swift%20-orange.svg)
![CocoaPods Version](https://img.shields.io/cocoapods/v/Butterfly.svg?style=flat)
![MIT License](https://img.shields.io/github/license/mashape/apistatus.svg)
![Platform](https://img.shields.io/badge/platform-%20iOS%20-lightgrey.svg)

Butterfly is a **lightweight** library for integrating bug-report and feedback features with shake-motion event elegantly. 

Just need two lines of code.

This project is inspired by Zhihu v3.0 originally.
## Goals of this project

One of the main issues accross the iOS development is the feedback of new features and bug report.

The most common way is to use `mailto` to send a dry and boring email :

````swift
let str = "mailto:foo@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!"
let url = NSURL(string: str)
UIApplication.sharedApplication().openURL(url)
````

Butterfly provides an elegant way to present users' feedback as easy as possible.

## Quick Look

![](./Screenshot/Demo.gif)

## Installation

### via [CocoaPod](http://cocoapods.org/)

    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '8.0'
    use_frameworks!

    pod 'Butterfly', '~> 0.3.13'

###  Manually
    
    $ git submodule add https://github.com/wongzigii/Butterfly.git

- Open the `Butterfly` folder, and drag `Butterfly.xcodeproj` into the file navigator of your app project, under your app project.
- In Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "Build Phases" panel.
- Add Kingfisher.framework within the "Target Dependencies"
- Click on the + button at the top left of "Build Phases" panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add Butterfly.framework.

## Usage

````swift
import Butterfly
````

````swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    ButterflyManager.sharedManager.startListeningShake()
    let uploader = ButterflyFileUploader.sharedUploader
    uploader.setValue( "sample", forParameter: "folderName" )
    uploader.setServerURLString("https://myserver.com/foo")
    return true
}
````

### How it works for uploading

`ButterflyViewController` delegate method invoked when send button pressed. You may want to implement this method to handle the image. However, in Xcode Version 6.4 (6E35b) with Swift 2.0, there currently seems to be no way to call static (class) methods defined in a protocol (in pure Swift).
Considering this issue, Butterfly included the `ButterflyFileUploader` to handle uploading stuff in v0.3.13. The `ButterflyFileUploader` class is an encapsulation under [Alamofire](https://github.com/Alamofire/Alamofire) 's upload API.

````swift
func ButterflyViewControllerDidPressedSendButton(drawView: ButterflyDrawView?) {
    if let image = imageWillUpload {
        let data: UIImage = image
        ButterflyFileUploader.sharedUploader.addFileData( UIImageJPEGRepresentation(data,0.8), withName: currentDate(), withMimeType: "image/jpeg" )
    }
        
    ButterflyFileUploader.sharedUploader.upload()
    print("ButterflyViewController 's delegate method [-ButterflyViewControllerDidEndReporting] invoked\n")
}
````

### Configuration of ButterflyFileUploader

**SereverURLString**

````swift
// @discussion Make sure your serverURLString is valid before a further application. 
// Call `setServerURLString` to replace the default "http://myserver.com/uploadFile" with your own's.
public var serverURLString: String? = "http://myserver.com/uploadFile"
    
///
/// Set uploader 's server URL
///
/// @param     URL         The server URL.
///
public func setServerURLString( URL: String ) {
    serverURLString = URL
}
````

````swift
///
/// Add one file or multiple files with file URL to uploader.
///
/// @param    url          The URL of the file whose content will be encoded into the multipart form data.
///
/// @param    name         The name to associate with the file content in the `Content-Disposition` HTTP header.
///
/// @param    mimeType     The MIME type to associate with the data in the `Content-Type` HTTP header.
///
public func addFileURL( url: NSURL, withName name: String, withMimeType mimeType: String? = nil ) {
    files.append( ButterflyFileUploadInfo( name: name, withFileURL: url, withMimeType: mimeType ) )
}
````

````swift
///
/// Add one file or multiple files with NSData to uploader.
///
/// @param    data         The data to encode into the multipart form data.
///
/// @param    name         The name to associate with the file content in the `Content-Disposition` HTTP header.
///
/// @param    mimeType     The MIME type to associate with the data in the `Content-Type` HTTP header.
///
public func addFileData( data: NSData, withName name: String, withMimeType mimeType: String = "application/octet-stream" ) {
    files.append( ButterflyFileUploadInfo( name: name, withData: data, withMimeType: mimeType ) )
}
````
For further information, please check out ButterflyFileUploader.swift.

## Contact

- Contact me on [Sina Weibo](http://weibo.com/wongzigii)
- Email [me](mailto:wongzigii@outlook.com)
- [Issue or require a new feature?](https://github.com/wongzigii/Butterfly/issues/new)

## License

Butterfly is under MIT LICENCE, see the [LICENCE](https://github.com/wongzigii/Butterfly/blob/master/LICENSE) file for more info.
