#
#  Be sure to run `pod spec lint WZSnakeHUD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Butterfly"
  s.version      = "0.1.0"
  s.summary      = "Integrate feedback module elegantly."
  s.homepage     = "http://www.wongzigii.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Wongzigii" => "wongzigii@outlook.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/wongzigii/Butterfly.git", :tag => "v#{s.version}" }
  s.source_files  = "Butterfly/Butterfly/*.swift"
  s.ios.resource_bundle = { 'Butterfly' => 'Butterfly/Butterfly/Logo/*.png' }
  s.requires_arc = true
 end

