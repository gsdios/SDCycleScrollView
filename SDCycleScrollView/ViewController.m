//
//  ViewController.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"

@interface ViewController () <SDCycleScrollViewDelegate, SDCycleScrollViewDataSource>

@property (nonatomic, strong) NSArray *imagesGroup;
@property (nonatomic, strong) NSArray *titlesGroup;

@property (nonatomic, strong) SDCycleScrollView *normalCycleScrollView;
@property (nonatomic, strong) SDCycleScrollView *titleCycleScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    self.imagesGroup = @[[UIImage imageNamed:@"h1.jpg"],
                         [UIImage imageNamed:@"h2.jpg"],
                         [UIImage imageNamed:@"h3.jpg"],
                         [UIImage imageNamed:@"h4.jpg"],
                         @"http://b.hiphotos.baidu.com/image/pic/item/1f178a82b9014a900fd77b8caa773912b31bee12.jpg",
                         @"http://g.hiphotos.baidu.com/image/pic/item/d01373f082025aaf2a132b38f9edab64034f1a1b.jpg",
                         ];
    
    self.titlesGroup = @[@"感谢您的支持，如果下载的",
                         @"如果代码在使用过程中出现问题",
                         @"您可以发邮件到gsdios@126.com",
                         @"感谢您的支持",
                         @"baby",
                         @"baby",
                         ];
    
    
    CGFloat w = self.view.bounds.size.width;
    
    // 创建不带标题的图片轮播器
    self.normalCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 60, w, 180) delegate:self dataSource:self];
    self.normalCycleScrollView.hidesForSinglePage = YES;
    self.normalCycleScrollView.dotSize = CGSizeMake(5, 5);
    //cycleScrollView.autoScrollTimeInterval = 2.0;
    [self.view addSubview:self.normalCycleScrollView];
    
    
    // 创建带标题的图片轮播器
    self.titleCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, w, 180) delegate:self dataSource:self];
    self.titleCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [self.view addSubview:self.titleCycleScrollView];
}

#pragma mark - SDCycleScrollViewDataSource

- (NSInteger)numberOfPages {
    return self.imagesGroup.count;
}

- (void)collectionViewCell:(SDCollectionViewCell *)cell pageForItemAtIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)cycleScrollView {
    if (cycleScrollView == self.normalCycleScrollView) {
        id item = self.imagesGroup[index];
        [self configrePageWithCollectonViewCell:cell atItem:item];
    } else if (cycleScrollView == self.titleCycleScrollView) {
        [self configrePageWithCollectonViewCell:cell atIndex:index];
    }
}

- (void)configrePageWithCollectonViewCell:(SDCollectionViewCell *)cell atItem:(id)item {
    if ([item isKindOfClass:[NSString class]]) {
        // 只是暂时使用，如果想用其他第三方库，可以自己选择哈
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:item]];
            if (imageData) {
                UIImage *downImage = [[UIImage alloc] initWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (downImage) {
                        cell.imageView.image = downImage;
                    }
                });
            }
        });
        
    } else {
        cell.imageView.image = item;
    }
}

- (void)configrePageWithCollectonViewCell:(SDCollectionViewCell *)cell atIndex:(NSInteger)index {
    id item = self.imagesGroup[index];
    [self configrePageWithCollectonViewCell:cell atItem:item];
    NSString *title = self.titlesGroup[index];
    cell.title = title;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了index为%ld的图片", (long)index);
}

@end
