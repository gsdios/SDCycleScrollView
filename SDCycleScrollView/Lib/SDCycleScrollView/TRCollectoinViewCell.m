//
//  TRCollectoinViewCell.m
//  SDCycleScrollView
//
//  Created by Mac mini on 16/1/7.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "TRCollectoinViewCell.h"

@interface TRCollectoinViewCell()
@property (nonatomic, readonly) UILabel *titleLabel;
@end

@implementation TRCollectoinViewCell
@synthesize titleLabel = _titleLabel;

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
    
    [self addSubview:self.titleLabel];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = [self title];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

-(UIColor *)bgColor
{
    return [UIColor blueColor];
}

-(NSString *)title
{
    return @"";
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _customView.frame = self.bounds;
    _titleLabel.frame = CGRectMake(0, 0, 150, 50);
    _titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
