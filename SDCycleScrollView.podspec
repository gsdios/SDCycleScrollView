Pod::Spec.new do |s|


s.name         = "SDCycleScrollView"
s.version      = "1.61"
s.summary      = "简单易用的图片无限轮播器.1.6版本升级内容：0.图片管理使用SDWebImage；1.优化内存，提升性能；2.添加图片contentmode接口；3.block监听点击接口；4.滚动到某张图片监听；5.增加自定义图片pageControl接口；6.其他等等。"

s.homepage     = "https://github.com/gsdios/SDCycleScrollView"

s.license      = "MIT"

s.author       = { "GSD_iOS" => "gsdios@126.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"


s.source       = { :git => "https://github.com/gsdios/SDCycleScrollView.git", :tag => "1.61"}


s.source_files  = "SDCycleScrollView/Lib/SDCycleScrollView/**/*.{h,m}"


s.requires_arc = true

s.dependency 'SDWebImage', '~> 3.7'

end
