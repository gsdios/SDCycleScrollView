Pod::Spec.new do |s|

s.name         = "SDCycleScrollView"
s.version      = "1.82"
s.summary      = "简单易用的图片无限轮播器. 1.82版本更新内容：修复iOS14上系统自带pagecontrol显示不出来bug"

s.homepage     = "https://github.com/gsdios/SDCycleScrollView"

s.license      = "MIT"

s.author       = { "GSD_iOS" => "gsdios@126.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/gsdios/SDCycleScrollView.git", :tag => s.version}


s.source_files  = "SDCycleScrollView/Lib/SDCycleScrollView/**/*.{h,m}"


s.requires_arc = true


s.dependency 'SDWebImage', '>= 5.0.0'

end
