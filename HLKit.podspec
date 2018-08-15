
Pod::Spec.new do |s|
s.name             = 'HLKit'
s.version          = '0.1.1'
s.summary          = 'A short description of HLKit.'

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/leohou/HLKit'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'leohou' => 'houli@wesai.com' }
s.source           = { :git => 'https://github.com/leohou/HLKit.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
s.source_files = 'HLKit/Classes/**/*'
 s.ios.deployment_target = '8.0'
#// 设置只依赖一个系统的library
# s.library = 'z'
s.libraries = 'z'
#s.xcconfig = {'HEADER_SEARCH_PATHS' =>'$(SDKROOT)/usr/'}
#s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/usr/include/**' }
# s.resource_bundles = {
#   'HLIntegrationlibrary' => ['HLKit/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'SystemConfiguration', 'UIKit', 'Security', 'CoreGraphics','CoreTelephony','AdSupport'
# s.dependency 'AFNetworking', '~> 2.3'
end

