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
/**
 *  Will display.
 */
- (void)willDisplay
{
    
}

/**
 *  Did end display.
 */
- (void)didEndDisplay
{
    
}

/**
 The contentOffset, you can use this value to do sth.
 
 @param offset The offset.
 */
- (void)contentOffset:(CGPoint)offset {
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, offset.y * 0.85f, self.imageView.frame.size.width, self.imageView.frame.size.height);
    }else{
        [self resetImageViewCenterPoint];
    }
}

- (void)resetImageViewCenterPoint {
    
    
    CGPoint point = [self convertPoint:CGPointZero toView:self.window];
    CGPoint newCenter = self.center;
    newCenter.x       = -0.9 * point.x + 187.5; // ?
    self.imageView.center       = newCenter;
}
@end
