Pod::Spec.new do |s|
　　s.name = "SDCycleScrollView"
　　s.version = "1.3.1"
　　s.license = "MIT"
　　s.summary = "简单易用的图片无限轮播器"
　　s.homepage = "https://github.com/gsdios/SDCycleScrollView"
　　s.author = { "GSD_iOS": "gsdios@126.com" }
   s.source = { :git => 'https://github.com/CodeEagle/SDCycleScrollView.git', :tag => s.version.to_s }
　　s.platform = :ios, "7.0"
　　s.source_files = "SDCycleScrollView/Lib/SDCycleScrollView/**/*.{h,m}"
　　s.screenshots = "http://ww4.sinaimg.cn/bmiddle/9b8146edjw1esvytq7lwrg208p0fce82.gif"
　　s.requires_arc = true
end
