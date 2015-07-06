#
#  Be sure to run `pod spec lint WZSnakeHUD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name = 'Butterfly'
  s.version = '0.3.0'
  s.license = 'MIT'
  s.summary = 'Integrate feedback module elegantly.'
  s.authors = { 'Wongzigii' => 'https://github.com/wongzigii' }
  s.homepage = 'https://github.com/wongzigii/Butterfly'
  s.source = { :git => 'https://github.com/wongzigii/Butterfly.git', :tag => "#{s.version}" }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Butterfly/*.{h,swift}'
  s.ios.resource_bundle = { 'Butterfly' => 'Butterfly/Logo/*.png' }
  s.dependency 'Alamofire', '~> 1.2'
end
