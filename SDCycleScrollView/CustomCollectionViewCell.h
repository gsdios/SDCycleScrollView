//
//  CustomCollectionViewCell.h
//  SDCycleScrollView
//
//  Created by 高少东 on 2017/6/24.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@end
