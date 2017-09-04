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
#import "SDCycleScrollView.h"
#import "CustomCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ViewController () <SDCycleScrollViewDelegate>

@end

@implementation ViewController
{
    NSArray *_imagesURLStrings;
    SDCycleScrollView *_customCellScrollViewDemo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"轮播Demo";
    
    NSArray *titleArr = @[@"如果要实现自定义cell的轮播图，必须先实现代理方法",@"由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的",@"网络加载 --- 创建只上下滚动展示文字的轮播器",@"新建交流QQ群：185534916,感谢您的支持，如果下载的,如果代码在使用过程中出现问题,您可以发邮件到gsdios@126.com,disableScrollGesture可以设置禁止拖动"];
    
    CGFloat w = self.view.bounds.size.width;
    
    // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    //富文本+超出固定宽度滚动 参数请到SDCollectionViewCell里面改(固定宽度 ,滚动间隔 ,延迟时间)
    SDCycleScrollView *cycleScrollView1 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 80, w, 20) delegate:self placeholderImage:nil];
    cycleScrollView1.backgroundColor = [UIColor whiteColor];
    cycleScrollView1.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView1.onlyDisplayText = YES;
    cycleScrollView1.textScrollEnable = YES;
    cycleScrollView1.titleLabelTextColor = [UIColor blackColor];
    
    NSMutableArray *attributeTitleArray = [NSMutableArray new];
    for (int i = 0; i < titleArr.count; i++) {
        NSString *titleStr = titleArr[i];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:titleStr];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
        [attributeTitleArray addObject:attr];
    }
    cycleScrollView1.displayType = SDDisplayTypeAttributeText;
    cycleScrollView1.titlesGroup = [attributeTitleArray copy];
    
    [self.view addSubview:cycleScrollView1];
    
    //正常文字+超出固定宽度滚动
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 120, w, 20) delegate:self placeholderImage:nil];
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    cycleScrollView2.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView2.onlyDisplayText = YES;
    cycleScrollView2.textScrollEnable = YES;
    cycleScrollView2.titleLabelTextColor = [UIColor blackColor];
    cycleScrollView2.displayType = SDDisplayTypeNormalText;
    cycleScrollView2.titlesGroup = titleArr;
    [self.view addSubview:cycleScrollView2];
    
    //正常文字+不滚动
    SDCycleScrollView *cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 160, w, 20) delegate:self placeholderImage:nil];
    cycleScrollView4.backgroundColor = [UIColor whiteColor];
    cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView4.onlyDisplayText = YES;
    //设置是否滚动
    cycleScrollView4.textScrollEnable = NO;
    cycleScrollView4.titleLabelTextColor = [UIColor blackColor];
    cycleScrollView4.displayType = SDDisplayTypeNormalText;
    cycleScrollView4.titlesGroup = titleArr;
    [self.view addSubview:cycleScrollView4];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果你发现你的CycleScrollview会在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
    //    [你的CycleScrollview adjustWhenControllerViewWillAppera];
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


// 不需要自定义轮播cell的请忽略下面的代理方法

// 如果要实现自定义cell的轮播图，必须先实现customCollectionViewCellClassForCycleScrollView:和setupCustomCell:forIndex:代理方法

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    if (view != _customCellScrollViewDemo) {
        return nil;
    }
    return [CustomCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    CustomCollectionViewCell *myCell = (CustomCollectionViewCell *)cell;
    [myCell.imageView sd_setImageWithURL:_imagesURLStrings[index]];
}

@end
