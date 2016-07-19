//
//  TATextPageControl.h
//  SDCycleScrollView
//
//  Created by lee on 16/7/18.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPageControl.h"

@interface TATextPageControl : UIControl


/**
 *  Number of pages for control. Default is 0.
 */
@property (nonatomic) NSInteger numberOfPages;


/**
 *  Current page on which control is active. Default is 0.
 */
@property (nonatomic) NSInteger currentPage;

@property(nonatomic,assign) id<TAPageControlDelegate> delegate;

@end
