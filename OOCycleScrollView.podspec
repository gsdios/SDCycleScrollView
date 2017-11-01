Pod::Spec.new do |s|


s.name         = "OOCycleScrollView"
s.version      = "2.0.2"
s.summary      = "简单易用的图片无限轮播器. swift版本 1.0.1版本修复内容：新增纯文字轮播、增加viewController在来回push时候出现的图片卡在中间的解决方案-在控制器viewWillAppear时调用adjustWhenControllerViewWillAppera"

s.homepage     = "https://github.com/gsdios/SDCycleScrollView"

s.license      = "MIT"

s.author       = { "GSD_iOS" => "gsdios@126.com",
		   "lijianwei" => "lijianwei.jj@gmail.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/lijianwei-jj/SDCycleScrollView.git", :tag => s.version }


s.source_files  = "SDCycleScrollView/Lib/OOCycleScrollView/**/*.swift"


s.requires_arc = true

s.dependency 'Kingfisher', '~> 3.0'
s.dependency 'DACircularProgress'

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
