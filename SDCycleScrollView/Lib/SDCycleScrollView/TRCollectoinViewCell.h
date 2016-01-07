//
//  TRCollectoinViewCell.h
//  SDCycleScrollView
//
//  Created by Mac mini on 16/1/7.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRCollectoinViewCell : UICollectionViewCell

@property (nonatomic, weak) UIView *customView;
@property (nonatomic, strong) UIColor *bgColor;

-(void)setupUI;
@end
