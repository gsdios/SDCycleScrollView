//
//  SDCycleScrollView.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/**
 
 *******************************************************
 *                                                      *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题    *
 * 您可以发邮件到gsdios@126.com 或者 到                       *
 * https://github.com/gsdios?tab=repositories 提交问题     *
 *                                                      *
 *******************************************************
 
 */


#import "SDCycleScrollView.h"
#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
#import "TAPageControl.h"
#import "NSData+SDDataCache.h"



NSString * const ID = @"cycleCell";

@interface SDCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *imagesGroup;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) TAPageControl *pageControl;

@end

@implementation SDCycleScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)initialization
{
    _pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _autoScrollTimeInterval = 1.0;
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont systemFontOfSize:14];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    self.backgroundColor = [UIColor lightGrayColor];
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup
{
    SDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imagesGroup = [NSMutableArray arrayWithArray:imagesGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLsGroup:(NSArray *)imageURLsGroup
{
    SDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imageURLsGroup = [NSMutableArray arrayWithArray:imageURLsGroup];
    return cycleScrollView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _flowLayout.itemSize = self.frame.size;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    _pageControl.dotSize = pageControlDotSize;
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    _pageControl.dotColor = dotColor;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [_timer invalidate];
    _timer = nil;
    [self setupTimer];
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[SDCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setImagesGroup:(NSMutableArray *)imagesGroup
{
    _imagesGroup = imagesGroup;
    _totalItemsCount = imagesGroup.count * 100;
    
    if (imagesGroup.count != 1) {
        [self setupTimer];
    } else {
        self.mainView.scrollEnabled = NO;
    }
    
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setImageURLsGroup:(NSArray *)imageURLsGroup
{
    _imageURLsGroup = imageURLsGroup;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageURLsGroup.count];
    for (int i = 0; i < imageURLsGroup.count; i++) {
        UIImage *image = [[UIImage alloc] init];
        [images addObject:image];
    }
    self.imagesGroup = images;
    [self loadImageWithImageURLsGroup:imageURLsGroup];
}

- (void)setLocalizationImagesGroup:(NSArray *)localizationImagesGroup
{
    _localizationImagesGroup = localizationImagesGroup;
    self.imagesGroup = [NSMutableArray arrayWithArray:localizationImagesGroup];
}

- (void)loadImageWithImageURLsGroup:(NSArray *)imageURLsGroup
{
    for (int i = 0; i < imageURLsGroup.count; i++) {
        [self loadImageAtIndex:i];
    }
}

- (void)loadImageAtIndex:(NSInteger)index
{
    NSURL *url = self.imageURLsGroup[index];
    
    // 如果有缓存，直接加载缓存
    NSData *data = [NSData getDataCacheWithIdentifier:url.absoluteString];
    if (data) {
        [self.imagesGroup setObject:[UIImage imageWithData:data] atIndexedSubscript:index];
    } else {
        
        // 网络加载图片并缓存图片
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
                                   if (!connectionError) {
                                       UIImage *image = [UIImage imageWithData:data];
                                       if (!image) return; // 防止错误数据导致崩溃
                                       [self.imagesGroup setObject:image atIndexedSubscript:index];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (index == 0) {
                                               [self.mainView reloadData];
                                           }
                                       });
                                       [data saveDataCacheWithIdentifier:url.absoluteString];
                                   } else { // 加载数据失败
                                       static int repeat = 0;
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           if (repeat > 10) return;
                                           [self loadImageAtIndex:index];
                                           repeat++;
                                       });
                                       
                                   }
                               }
         
         ];
    }
    
}


- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    TAPageControl *pageControl = [[TAPageControl alloc] init];
    pageControl.numberOfPages = self.imagesGroup.count;
    pageControl.dotColor = self.dotColor;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}


- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount) {
        targetIndex = _totalItemsCount * 0.5;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = [_pageControl sizeForNumberOfPages:self.imagesGroup.count];
    CGFloat x = (self.sd_width - size.width) * 0.5;
    if (self.pageControlAliment == SDCycleScrollViewPageContolAlimentRight) {
        x = self.mainView.sd_width - size.width - 10;
    }
    CGFloat y = self.mainView.sd_height - size.height - 10;
    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
    [_pageControl sizeToFit];
}
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imagesGroup.count;
    UIImage *image = self.imagesGroup[itemIndex];
    if (image.size.width == 0 && self.placeholderImage) {
        image = self.placeholderImage;
    }
    cell.imageView.image = image;
    if (_titlesGroup.count) {
        cell.title = _titlesGroup[itemIndex];
    }
    
    if (!cell.hasConfigured) {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.titleLabelTextColor = self.titleLabelTextColor;
        cell.titleLabelTextFont = self.titleLabelTextFont;
        cell.hasConfigured = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.imagesGroup.count];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.mainView.sd_width * 0.5) / self.mainView.sd_width;
    if (!self.imagesGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int indexOnPageControl = itemIndex % self.imagesGroup.count;
    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

/**
 
 (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval { _autoScrollTimeInterval = autoScrollTimeInterval; [self setupTimer]; } 每设置一次autoScrollTimeInterval就会多一个timer. 同理还有这里 - (void)setImagesGroup:(NSMutableArray *)imagesGroup. 在setupTimer中一次性加上其他地方写过的
 [_timer invalidate]; _timer = nil; 2.建议用约束写collectionView和pageControl,就能在xib中用约束直接这个控件; 3.建议增加placeholderImage和pageControlBackgroundColor属性. 4..pageControl的valuechange事件也可以带动scrollView的滚动
 
 */

@end
