# SDCycleScrollView
无限循环自动图片轮播器(一步设置即可使用)

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: imagesGroup:图片数组];
    
    
 ---------------------------------------------------------------------------------------------------------------
 
 PS:
 
 如果需要网络加载图片，请下载 https://github.com/gsdios/SDCycleScrollView/tree/%E6%94%AF%E6%8C%81%E7%BD%91%E7%BB%9C%E5%8A%A0%E8%BD%BD%E7%89%88%E6%9C%AC%EF%BC%88%E7%AE%80%E5%8D%95%E6%98%93%E7%94%A8%EF%BC%89 （简单易用版）  
 或者 
 https://github.com/gsdios/SDCycleScrollView/tree/%E9%AB%98%E5%BA%A6%E6%89%A9%E5%B1%95%E5%92%8C%E8%87%AA%E5%AE%9A%E4%B9%89%E7%89%88%E6%9C%AC （支持高度自定义版）
 
 如需更详细的设置，参考如下：
 
 1. cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight; // 设置pageControl居右，默认居中
 
 2. cycleScrollView.titlesGroup =  标题数组（数组元素个数必须和图片数组元素个数保持一致）; // 如果设置title数组，则会在图片下面添加标题
 
 3. cycleScrollView.delegate = ; // 如需监听图片点击，请设置代理，实现代理方法
 
 4. cycleScrollView.autoScrollTimeInterval = ;// 自定义轮播时间间隔 


![](http://cdn.cocimg.com/bbs/attachment/Fid_19/19_441660_d01407e9c4b63d1.gif)
