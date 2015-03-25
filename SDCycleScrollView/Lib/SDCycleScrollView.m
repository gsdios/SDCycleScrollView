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



NSString * const ID = @"cycleCell";

@interface SDCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) TAPageControl *pageControl;

@end

@implementation SDCycleScrollView

#pragma mark - Life Cycle

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    _dotSize = CGSizeMake(8, 8);
    _hidesForSinglePage = NO;
    _pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _autoScrollTimeInterval = 4.0;
    
    [self setupMainView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
                                delegate:(id <SDCycleScrollViewDelegate>)delegate
                              dataSource:(id <SDCycleScrollViewDataSource>)dataSource
{
    SDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.dataSource = dataSource;
    return cycleScrollView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _flowLayout.itemSize = self.frame.size;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.frame = self.bounds;
    if (_totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    NSInteger numberOfPages = [self numberOfPages];
    
    CGSize size = [_pageControl sizeForNumberOfPages:numberOfPages];
    CGFloat x = (self.sd_width - size.width) * 0.5;
    if (self.pageControlAliment == SDCycleScrollViewPageContolAlimentRight) {
        x = self.mainView.sd_width - size.width - 10;
    }
    CGFloat y = self.mainView.sd_height - size.height - 10;
    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
    [_pageControl sizeToFit];
}

#pragma mark - 公开方法

- (void)reloadData {
    NSInteger numberOfPages = [self numberOfPages];
    
    NSInteger reusePageOffset = 1;
    if (numberOfPages > 1) {
        reusePageOffset = 100;
        [self setupTimer];
    }
    _totalItemsCount = numberOfPages * reusePageOffset;
    
    [self setupPageControl];
    
    [self.mainView reloadData];
    
    [self setNeedsLayout];
}

#pragma mark - Setup Helper Method

// 设置显示图片的collectionView
- (void)setupMainView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    mainView.backgroundColor = self.backgroundColor;
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[SDCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setupPageControl {
    if (!_pageControl) {
        TAPageControl *pageControl = [[TAPageControl alloc] init];
        pageControl.dotSize = self.dotSize;
        pageControl.hidesForSinglePage = self.hidesForSinglePage;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    NSInteger numberOfPages = [self numberOfPages];
    _pageControl.numberOfPages = numberOfPages;
    _pageControl.currentPage = 0;
}

- (void)automaticScroll {
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount) {
        targetIndex = _totalItemsCount * 0.5;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setupTimer {
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Propertys

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [_timer invalidate];
    _timer = nil;
    [self setupTimer];
}

- (void)setDotSize:(CGSize)dotSize {
    _dotSize = dotSize;
    self.pageControl.dotSize = dotSize;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
    self.pageControl.hidesForSinglePage = hidesForSinglePage;
}

- (NSInteger)numberOfPages {
    return [self.dataSource numberOfPages];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSInteger numberOfPages = [self numberOfPages];
    
    NSInteger itemIndex = indexPath.item % numberOfPages;
    
    [self.dataSource collectionViewCell:cell pageForItemAtIndex:itemIndex cycleScrollView:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        NSInteger numberOfPages = [self numberOfPages];
        
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % numberOfPages];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.mainView.sd_width * 0.5) / self.mainView.sd_width;
    NSInteger numberOfPages = [self numberOfPages];

    int indexOnPageControl = itemIndex % numberOfPages;
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



@end
