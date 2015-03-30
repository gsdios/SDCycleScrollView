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
#import "SDCollectionViewCell.h"

typedef enum {
    SDCycleScrollViewPageContolAlimentRight,
    SDCycleScrollViewPageContolAlimentCenter
} SDCycleScrollViewPageContolAliment;

@class SDCycleScrollView;

@protocol SDCycleScrollViewDelegate <NSObject>

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@protocol SDCycleScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPages;
- (void)collectionViewCell:(SDCollectionViewCell *)cell pageForItemAtIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)cycleScrollView;

@end

@interface SDCycleScrollView : UIView

@property (nonatomic, weak) id <SDCycleScrollViewDelegate> delegate;
@property (nonatomic, weak) id <SDCycleScrollViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
@property (nonatomic, assign) SDCycleScrollViewPageContolAliment pageControlAliment;

/**
 *  Dot size for dot views. Default is 8 by 8.
 */
@property (nonatomic) CGSize dotSize;

/**
 *  Hide the control if there is only one page. Default is NO.
 */
@property (nonatomic) BOOL hidesForSinglePage;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
                                delegate:(id <SDCycleScrollViewDelegate>)delegate
                              dataSource:(id <SDCycleScrollViewDataSource>)dataSource;

- (void)reloadData;

@end
