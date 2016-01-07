//
//  TRCollectoinViewCell.m
//  SDCycleScrollView
//
//  Created by Mac mini on 16/1/7.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "TRCollectoinViewCell.h"

@implementation TRCollectoinViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIView *contentView = [UIView new];
    _customView = contentView;
    _customView.backgroundColor = [self bgColor];
    [self addSubview:_customView];
}

-(UIColor *)bgColor
{
    return [UIColor blueColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _customView.frame = self.bounds;
}

@end
