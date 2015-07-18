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

    pod 'Butterfly', '~> 0.3.0'

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
    return true
}
````

## Contact

- Contact me on [Sina Weibo](http://weibo.com/wongzigii)
- Email [me](mailto:wongzigii@outlook.com)

## License

Butterfly is under MIT LICENCE, see the [LICENCE](https://github.com/wongzigii/Butterfly/blob/master/LICENSE) file for more info.
