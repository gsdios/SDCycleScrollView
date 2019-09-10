//
//  CustomCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by 高少东 on 2017/6/24.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _imageView = [UIImageView new];
    _imageView.layer.borderColor = [[UIColor redColor] CGColor];
    _imageView.layer.borderWidth = 2;
    [self.contentView addSubview:_imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end
