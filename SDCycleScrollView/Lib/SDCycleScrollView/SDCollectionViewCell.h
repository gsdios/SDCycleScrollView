//
//  SDCollectionViewCell.h
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 SDCycleScrollView修改版 🌟🌟🌟
 *
 * 根据SDCycleScrollView修改的，修改了一些存在的bug，并添加了个新功能，数据源可以是个UIView的数组。
 * QQ: 382493496
 * Email: Dabo_iOS@163.com
 * GitHub: https://github.com/lianxingbo
 *
 * 原版GitHub: https://github.com/gsdios/SDCycleScrollView
 *
 *********************************************************************************
 
 */



#import <UIKit/UIKit.h>

@interface SDCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

@property (nonatomic, assign) BOOL hasConfigured;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;

/** 需要展示的是view */
@property (nonatomic, assign) BOOL isDisplayView;

@end
