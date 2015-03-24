# SDCycleScrollView
无限循环图片轮播器(一步设置即可使用)

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: imagesGroup:图片数组];
    
    
 ---------------------------------------------------------------------------------------------------------------
 
 PS:
 
 如需更详细的设置，参考如下：
 
 1. cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight; // 设置pageControl居右，默认居中
 
 2. cycleScrollView.titlesGroup = titles; // 如果设置title数组，则会在图片下面添加标题
 
 3. cycleScrollView.delegate = self; // 如需监听图片点击，请设置代理，实现代理方法
