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
 * 🌟🌟🌟 SDCycleScrollView修改版 🌟🌟🌟
 *
 * 根据SDCycleScrollView修改的，修改了一些存在的bug，并添加了个新功能，数据源可以是个UIView的数组。
 * QQ: 382493496
 * Email: Dabo_iOS@163.com
 * GitHub: https://github.com/lianxingbo
 *
 * 原版GitHub: https://github.com/gsdios/SDCycleScrollView
 *
 *********************************************************************************
 
 */

#import "ViewController.h"
#import "SDCycleScrollView.h"
#define kScrollViewWidth self.view.bounds.size.width
@interface ViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *demoContainerView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *viewArr;

@property (nonatomic, strong) NSArray *imagesURLStrings;

@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    self.title = @"轮播Demo";
    [self thirdScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果你发现你的CycleScrollview会在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
    //    [你的CycleScrollview adjustWhenControllerViewWillAppera];
}

#pragma mark - custom method

// 本地加载 --- 创建不带标题的图片轮播器
- (void)firstScrollView{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, kScrollViewWidth, 180) shouldInfiniteLoop:YES imageNamesGroup:self.imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.demoContainerView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    //cycleScrollView.autoScrollTimeInterval = 4.0;
}

// 网络加载 --- 创建带标题的图片轮播器
- (void)secondScrollView{
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, kScrollViewWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.titlesGroup = self.titles;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.demoContainerView addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = self.imagesURLStrings;
    });
    
    /*
     block监听点击方式
     
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
     NSLog(@">>>>>  %ld", (long)index);
     };
     
     */
    
}

// UIView轮播
- (void)thirdScrollView{
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 500, kScrollViewWidth, 180) shouldInfiniteLoop:YES viewGroup:self.viewArr];
    cycleScrollView3.delegate = self;
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView3.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.demoContainerView addSubview:cycleScrollView3];
}

// 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
- (void)fourthScrollView{
    SDCycleScrollView *cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 750, kScrollViewWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView4.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView4.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView4.imageURLStringsGroup = self.imagesURLStrings;
    
    [self.demoContainerView addSubview:cycleScrollView4];
}

//纯文字轮播
- (void)fifthScrollView{
    // 网络加载 --- 创建只上下滚动展示文字的轮播器
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    SDCycleScrollView *cycleScrollView5 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 1000, kScrollViewWidth, 40) delegate:self placeholderImage:nil];
    cycleScrollView5.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView5.onlyDisplayText = YES;
    
    NSMutableArray *titlesArray = [NSMutableArray new];
    [titlesArray addObject:@"纯文字上下滚动轮播"];
    [titlesArray addObject:@"纯文字上下滚动轮播 -- demo轮播图4"];
    [titlesArray addObjectsFromArray:self.titles];
    cycleScrollView5.titlesGroup = [titlesArray copy];
    
    [self.demoContainerView addSubview:cycleScrollView5];
}

- (UIView *)createTipView:(NSDictionary *)dict{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,kScrollViewWidth,180}];
    view.backgroundColor = dict[@"backgroundColor"];
    
    UILabel *parkingName = [[UILabel alloc] initWithFrame:(CGRect){20,20,80,20}];
    parkingName.text = dict[@"parkingName"];
    [view addSubview:parkingName];
    
    UILabel *carNum = [[UILabel alloc] initWithFrame:(CGRect){20,50,80,20}];
    carNum.text = dict[@"carNum"];
    [view addSubview:carNum];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 50, 50, 20);
    btn.tag = [dict[@"btnTag"] integerValue];
    [btn setTitle:@"立即缴费" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tipViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
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

#pragma mark - event response
- (void)tipViewBtnClick:(UIButton *)btn{
    
}

#pragma mark - setters and getters

- (UIScrollView *)demoContainerView{
    if (!_demoContainerView) {
        _demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
        [self.view addSubview:_demoContainerView];
    }
    return _demoContainerView;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"新建交流QQ群：185534916 ",
                    @"感谢您的支持，如果下载的",
                    @"如果代码在使用过程中出现问题",
                    @"您可以发邮件到gsdios@126.com"
                    ];
    }
    return _titles;
}

- (NSArray *)viewArr{
    if (!_viewArr) {
        
        NSDictionary *dict1 = @{
                                @"backgroundColor" : [UIColor cyanColor],
                                @"parkingName" : @"中关村大厦停车场",
                                @"carNum" : @"京A·2286",
                                @"btnTag" : @"998"
                                };
        UIView *view1 = [self createTipView:dict1];
        
        NSDictionary *dict2 = @{
                                @"backgroundColor" : [UIColor greenColor],
                                @"parkingName" : @"五道口停车场",
                                @"carNum" : @"京J·1051",
                                @"btnTag" : @"999"
                                };
        UIView *view2 = [self createTipView:dict2];
        
        NSDictionary *dict3 = @{
                                @"backgroundColor" : [UIColor orangeColor],
                                @"parkingName" : @"北大附中停车场",
                                @"carNum" : @"京N·9673",
                                @"btnTag" : @"1000"
                                };
        UIView *view3 = [self createTipView:dict3];
        
        _viewArr = @[view1,view2,view3];
    }
    return _viewArr;
}

- (NSArray *)imageNames{
    if (!_imageNames) {
        _imageNames = @[@"h1.jpg",
                                @"h2.jpg",
                                @"h3.jpg",
                                @"h4.jpg",
                                @"h7" // 本地图片请填写全名
                                ];
    }
    return _imageNames;
}

- (NSArray *)imagesURLStrings{
    if (!_imagesURLStrings) {
        _imagesURLStrings = @[
                              @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                              @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                              @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                              ];
    }
    return _imagesURLStrings;
}

@end
