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

@implementation TRCycleScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super setupMainViewAndPageControl];
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
}

//重写父类的方法
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

//总共有多少自定义的view
-(NSInteger)countOfItems
{
    return kTRCellCount;
}

@end
