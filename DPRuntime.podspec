#
#  Be sure to run `pod spec lint DPRuntime.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

 

  s.name         = "DPRuntime"
  s.version      = "0.0.1"
  s.summary      = "一个用runtime写的可以监听对象和类方法参数的小工具"




  s.homepage     = "https://github.com/HolyLe/DPRuntime.git"





  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

   s.author             = { "麻小亮" => "zshnr1993@qq.com" }
   s.platform     = :ios, "8.0"

   s.source       = { :git => "https://github.com/HolyLe/DPRuntime.git", :tag =>          s.version.to_s } 


  s.source_files  = "DPRuntime/Tool/*.{h,m}"
 



 

  s.framework  = "CoreGraphics"

  s.requires_arc = true

end
