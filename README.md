# SDCycleScrollView（新建QQ交流群：185534916）
## ☆☆☆ “iOS图片、文字轮播器” ☆☆☆

### 支持pod导入
pod 'SDCycleScrollView','~> 1.64'

 如果发现pod search SDCycleScrollView 搜索出来的不是最新版本，需要在终端执行cd转换文件路径命令退回到desktop，然后执行pod setup命令更新本地spec缓存（可能需要几分钟），然后再搜索就可以了

### 更改记录：

2016.05.27 -- 新增纯文字轮播、增加viewController在来回push时候出现的图片卡在中间的解决方案“解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用 adjustWhenControllerViewWillAppera”

2016.04.21 -- 修复自定义图片的pagecontrol刷新图片数据时崩溃bug；设置单张图片时停止轮播

2016.03.31 -- 增加垂直方向滚动功能

2016.01.21 -- 修复加载时出现item size zero提示问题

2016.01.15 -- 兼容assets存放的本地图片

2016.01.06 -- 0.图片管理使用SDWebImage；1.优化内存，提升性能；2.添加图片contentmode接口；3.block监听点击接口；4.滚动到某张图片监听；5.增加自定义图片pageControl接口；6.其他等等。其中有一处接口改动：pagecontrol的小圆点自定义接口改为：currentPageDotColor、pageDotColor、currentPageDotImage、pageDotImage。

           
### 无限循环自动图片轮播器(一步设置即可使用)

     // 网络加载图片的轮播器
     SDCycleScrollView *cycleScrollView = [cycleScrollViewWithFrame:frame delegate:delegate placeholderImage:placeholderImage];
     cycleScrollView.imageURLStringsGroup = imagesURLStrings;
     
     // 本地加载图片的轮播器
     SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: imagesGroup:图片数组];
    
    
 ---------------------------------------------------------------------------------------------------------------
 
## ??? 为什么我用这个轮播期会在顶部出现一块空白区域
以下是本库的使用者给出的一些解决方法放在这里供大家参考：
在iOS 7以后，controller 会对其中唯一的scrollView或其子类调整内边距，从而导致位置不准确。设置self.automaticallyAdjustsScrollViewInsets = NO;或者controller中放置不止一个scrollView或其子类时，就不会出现这种问题。以上原因是我的猜测，只要我设置了 self.automaticallyAdjustsScrollViewInsets = NO就没有那个问题了。
 
#PS:
 
 如需更详细的设置，参考如下：
 
 1. cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight; // 设置pageControl居右，默认居中
 
 2. cycleScrollView.titlesGroup =  标题数组（数组元素个数必须和图片数组元素个数保持一致）; // 如果设置title数组，则会在图片下面添加标题
 
 3. cycleScrollView.delegate = ; // 如需监听图片点击，请设置代理，实现代理方法
 
 4. cycleScrollView.autoScrollTimeInterval = ;// 自定义轮播时间间隔 

![](http://ww4.sinaimg.cn/bmiddle/9b8146edjw1esvytq7lwrg208p0fce82.gif)

![](http://cdn.cocimg.com/bbs/attachment/Fid_19/19_441660_d01407e9c4b63d1.gif)
