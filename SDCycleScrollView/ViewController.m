//
//  ViewController.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */

#import "ViewController.h"
//#import "SDCycleScrollView.h"
#import "SDCycleScrollView-Swift.h"

@interface ViewController () <OOCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 3000);
    [self.view addSubview:demoContainerView];
    
    self.title = @"轮播Demo";

    
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg",
                            @"h7" // 本地图片请填写全名
                            ];
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    NSArray *imagesURLStringsT = @[
                                   @"http://www.jvnan.com/uploads/160516/2_160715_8.jpg",
                                   @"http://www.qqpifu.org/wp-content/uploads/fzlmm/8638.jpg",
                                   @"http://www.51mtw.com/UploadFiles/2013-10/admin/2013101208472246086.jpg",
                                   @"http://www.showself.com/yule/uploadfile/2016/0127/20160127055117316.jpg",
                                   @"http://www.jvnan.com/uploads/160516/2_160715_8.jpg",
                                   @"http://img2.suv.cn/2013/0419/20130419082325963.jpg",
                                   @"http://mm.voimm.com/vimg/2015-09-06/20159603857306.jpg",
                                   @"http://pic.ik6.cc:85/d/meinv2/neirong/18/31/qqiy5r1hz3l.jpg",
                                   @"http://photo.880sy.com/4/2883/110302.jpg",
                                   @"http://img.faxingw.cn/201305/nn4.jpg",
                                   @"http://mm.voimm.com/vimg/2015-09-06/20159604035560.jpg",
                                   @"http://mm.voimm.com/vimg/2015-07-14/20157149539525.jpg",
                                   @"https://pbs.twimg.com/profile_images/448033128108417024/UHPZFwLk.jpeg"
                                  ];
    
    
    
    // 情景三：图片配文字
    NSArray *titles = @[@"新建交流QQ群：185534916 ",
                        @"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com"
                        ];
    
    CGFloat w = self.view.bounds.size.width;
    
    

// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 本地加载 --- 创建不带标题的图片轮播器
    OOCycleScrollView *cycleScrollView = [OOCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, w, 180) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = OOCycleScrollViewPageContolStyleAnimated;
    [demoContainerView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    //cycleScrollView.autoScrollTimeInterval = 4.0;
    
    
// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 网络加载 --- 创建带标题的图片轮播器
    OOCycleScrollView *cycleScrollView2 = [OOCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView2.pageControlAliment = OOCycleScrollViewPageContolStyleClassic;
    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [demoContainerView addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
    
    /*
     block监听点击方式
     
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        NSLog(@">>>>>  %ld", (long)index);
     };
     
     */
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    OOCycleScrollView *cycleScrollView3 = [OOCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 500, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    
    [demoContainerView addSubview:cycleScrollView3];
    
    // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图4 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 网络加载 --- 创建只上下滚动展示文字的轮播器
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    OOCycleScrollView *cycleScrollView4 = [OOCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 750, w, 40) delegate:self placeholderImage:nil];
    cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView4.onlyDisplayText = YES;
    
    NSMutableArray *titlesArray = [NSMutableArray new];
    [titlesArray addObject:@"纯文字上下滚动轮播"];
    [titlesArray addObject:@"纯文字上下滚动轮播 -- demo轮播图4"];
    [titlesArray addObjectsFromArray:titles];
    cycleScrollView4.titlesGroup = [titlesArray copy];
    
    [demoContainerView addSubview:cycleScrollView4];
    
// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图5 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    OOCycleScrollView *cycleScrollView5 = [OOCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 900, w, 180) imageURLStringsGroup:imagesURLStrings];;
    cycleScrollView5.pageControlStyle = OOCycleScrollViewPageContolStyleText;
    cycleScrollView5.autoScroll = NO;
    [demoContainerView addSubview:cycleScrollView5];
    
    
    
    OOCycleScrollView *cycleScrollView6 = [OOCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 1100, w, w*1.4) imageURLStringsGroup:imagesURLStringsT];;
    cycleScrollView6.pageControlStyle = OOCycleScrollViewPageContolStyleText;
    cycleScrollView6.placeholderImage = [UIImage imageNamed:@"kb"];
    cycleScrollView6.autoScroll = NO;
    [demoContainerView addSubview:cycleScrollView6];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果你发现你的CycleScrollview会在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
//    [你的CycleScrollview adjustWhenControllerViewWillAppera];
}


#pragma mark - SDCycleScrollViewDelegate
/*
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}
*/

-(void)cycleScrollView:(OOCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

/*
 
// 滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}
 
 */

@end
