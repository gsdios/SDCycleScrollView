Pod::Spec.new do |s|

s.name         = "SDCycleScrollView"
s.version      = "1.66"
s.summary      = "简单易用的图片无限轮播器. 1.66版本修复内容：更新SDWebImage依赖版本至4.0.0"

s.homepage     = "https://github.com/gsdios/SDCycleScrollView"

s.license      = "MIT"

s.author       = { "GSD_iOS" => "gsdios@126.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"


s.source       = { :git => "https://github.com/gsdios/SDCycleScrollView.git", :tag => "1.66"}


s.source_files  = "SDCycleScrollView/Lib/SDCycleScrollView/**/*.{h,m}"


s.requires_arc = true


s.dependency 'SDWebImage', '~> 4.0.0'

end
