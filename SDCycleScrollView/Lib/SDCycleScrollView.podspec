Pod::Spec.new do |s|

s.name         = "SDCycleScrollView"
s.version      = "1.75"
s.summary      = "简单易用的图片无限轮播器. 1.75版本更新内容：支持 Carthage"

s.homepage     = "https://github.com/gsdios/SDCycleScrollView"

s.license      = "MIT"

s.author       = { "GSD_iOS" => "gsdios@126.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/gsdios/SDCycleScrollView.git", :tag => "1.74"}


s.source_files  = "SDCycleScrollView/**/*.{h,m}"


s.requires_arc = true


s.dependency 'SDWebImage', '>= 4.0.0'

end
