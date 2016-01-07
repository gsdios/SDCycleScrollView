//
//  TRCycleScrollView.m
//  SDCycleScrollView
//
//  Created by Mac mini on 16/1/7.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "TRCycleScrollView.h"
#import "TRCollectoinViewCell.h"
#import "TRFirstCell.h"
#import "TRSecondCell.h"
#import "TRThirdCell.h"

NSString * const FirstID = @"firstcycleCell";
NSString * const SecondID = @"secondcycleCell";
NSString * const ThirdID = @"thirdcycleCell";


#define kTRCellCount 3
@interface TRCycleScrollView()

@property (nonatomic, assign) NSInteger totalItemsCount;

@end

@implementation TRCycleScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _totalItemsCount = kTRCellCount * 100;

        [super setAutoScroll:YES];
        [super setupPageControl];
    }
    return self;
    
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    [super setupMainView];
    [self.mainView registerClass:[TRFirstCell class] forCellWithReuseIdentifier:FirstID];
    [self.mainView registerClass:[TRSecondCell class] forCellWithReuseIdentifier:SecondID];
    [self.mainView registerClass:[TRThirdCell class] forCellWithReuseIdentifier:ThirdID];
    self.mainView.scrollEnabled = YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    long itemIndex = indexPath.item % kTRCellCount;
    NSString *cellIndentifier = FirstID;
    switch (itemIndex) {
        case 0:
            cellIndentifier = FirstID;
            break;
        case 1:
            cellIndentifier = SecondID;
            break;
        case 2:
            cellIndentifier = ThirdID;
            break;
        default:
            cellIndentifier = FirstID;
            break;
    }
    TRCollectoinViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    
    return cell;
}

@end
