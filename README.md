# SDCycleScrollView
无限循环自动图片轮播器(可自定义扩展版本)

>> pragma mark - SDCycleScrollViewDataSource

- (NSInteger)numberOfPages {}

- (void)collectionViewCell:(SDCollectionViewCell *)cell pageForItemAtIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)cycleScrollView {}

- (void)configrePageWithCollectonViewCell:(SDCollectionViewCell *)cell atItem:(id)item {}

- (void)configrePageWithCollectonViewCell:(SDCollectionViewCell *)cell atIndex:(NSInteger)index {}

>> pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{}
    
    
 ---------------------------------------------------------------------------------------------------------------
 
 PS:
 
 如需更详细的设置，参考如下：
 
 1. cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight; // 设置pageControl居右，默认居中
 
 2. cycleScrollView.autoScrollTimeInterval = ;// 自定义轮播时间间隔 


![](http://cdn.cocimg.com/bbs/attachment/Fid_19/19_441660_d01407e9c4b63d1.gif)
