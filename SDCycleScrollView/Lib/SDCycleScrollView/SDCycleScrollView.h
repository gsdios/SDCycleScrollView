//
//  SDCycleScrollView.h
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


#import <UIKit/UIKit.h>

typedef enum {
    SDCycleScrollViewPageContolAlimentRight,
    SDCycleScrollViewPageContolAlimentCenter
} SDCycleScrollViewPageContolAliment;

@class SDCycleScrollView;

@protocol SDCycleScrollViewDelegate <NSObject>

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface SDCycleScrollView : UIView

@property (nonatomic, strong) NSArray *localizationImagesGroup; // 本地图片数组
@property (nonatomic, strong) NSArray *imageURLsGroup;
@property (nonatomic, strong) NSArray *titlesGroup;
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
@property (nonatomic, weak) id<SDCycleScrollViewDelegate> delegate;

// 自定义样式
@property (nonatomic, assign) SDCycleScrollViewPageContolAliment pageControlAliment; // 分页控件位置
@property (nonatomic, assign) CGSize pageControlDotSize; // 分页控件小圆标大小
@property (nonatomic, strong) UIColor *dotColor; // 分页控件小圆标颜色
@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;



+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLsGroup:(NSArray *)imageURLsGroup;

@end
