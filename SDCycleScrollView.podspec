Pod::Spec.new do |s|


s.name         = "SDCycleScrollView"
s.version      = "1.63"
s.summary      = "简单易用的图片无限轮播器. 1.63版本修复内容：修复自定义图片的pagecontrol刷新图片数据时崩溃bug；设置单张图片时停止轮播"

s.homepage     = "https://github.com/gsdios/SDCycleScrollView"

s.license      = "MIT"

s.author       = { "GSD_iOS" => "gsdios@126.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"


s.source       = { :git => "https://github.com/gsdios/SDCycleScrollView.git", :tag => "1.63"}


s.source_files  = "SDCycleScrollView/Lib/SDCycleScrollView/**/*.{h,m}"


s.requires_arc = true

s.dependency 'SDWebImage', '~> 3.7'

end
