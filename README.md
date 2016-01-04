# SDCycleScrollView（新建QQ交流群：185534916）
## ☆☆☆ “iOS第一轮播图” ☆☆☆
无限循环自动图片轮播器(一步设置即可使用)

     // 网络加载图片的轮播器
     cycleScrollView.imageURLStringsGroup = imagesURLStrings;
     
     // 本地加载图片的轮播器
     SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: imagesGroup:图片数组];
    
    
 ---------------------------------------------------------------------------------------------------------------
 
## ??? 为什么我用这个轮播期会在顶部出现一块空白区域
以下是本库的使用者给出的一些解决方法放在这里供大家参考：
在iOS 7以后，controller 会对其中唯一的scrollView或其子类调整内边距，从而导致位置不准确。设置self.automaticallyAdjustsScrollViewInsets = NO;或者controller中放置不止一个scrollView或其子类时，就不会出现这种问题。以上原因是我的猜测，只要我设置了 self.automaticallyAdjustsScrollViewInsets = NO就没有那个问题了。
 
#PS:
 
 现已支持cocoapods导入：pod 'SDCycleScrollView','~> 1.3'
 
 
 如需更详细的设置，参考如下：
 
 1. cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight; // 设置pageControl居右，默认居中
 
 2. cycleScrollView.titlesGroup =  标题数组（数组元素个数必须和图片数组元素个数保持一致）; // 如果设置title数组，则会在图片下面添加标题
 
 3. cycleScrollView.delegate = ; // 如需监听图片点击，请设置代理，实现代理方法
 
 4. cycleScrollView.autoScrollTimeInterval = ;// 自定义轮播时间间隔 

![](http://ww4.sinaimg.cn/bmiddle/9b8146edjw1esvytq7lwrg208p0fce82.gif)

![](http://cdn.cocimg.com/bbs/attachment/Fid_19/19_441660_d01407e9c4b63d1.gif)
