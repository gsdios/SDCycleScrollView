# SDCycleScrollView
无限循环自动图片轮播器(一步设置即可使用)

     // 网络加载图片的轮播器
     cycleScrollView.imageURLStringsGroup = imagesURLStrings;
     
     // 本地加载图片的轮播器
     SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: imagesGroup:图片数组];
    
    
 ---------------------------------------------------------------------------------------------------------------
 
 PS:
 
 
 如需更详细的设置，参考如下：
 
 1. cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight; // 设置pageControl居右，默认居中
 
 2. cycleScrollView.titlesGroup =  标题数组（数组元素个数必须和图片数组元素个数保持一致）; // 如果设置title数组，则会在图片下面添加标题
 
 3. cycleScrollView.delegate = ; // 如需监听图片点击，请设置代理，实现代理方法
 
 4. cycleScrollView.autoScrollTimeInterval = ;// 自定义轮播时间间隔 

![](http://ww4.sinaimg.cn/bmiddle/9b8146edjw1esvytq7lwrg208p0fce82.gif)

![](http://cdn.cocimg.com/bbs/attachment/Fid_19/19_441660_d01407e9c4b63d1.gif)
