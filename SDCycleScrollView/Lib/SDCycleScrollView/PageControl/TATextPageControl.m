//
//  TATextPageControl.m
//  SDCycleScrollView
//
//  Created by lee on 16/7/18.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "TATextPageControl.h"

@interface TATextPageControl ()

@property (nonatomic, strong) UILabel *textPage;

@end

@implementation TATextPageControl


- (id)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    self.layer.masksToBounds = YES;
    _textPage = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 0, 23, 20)];
    _textPage.textAlignment = NSTextAlignmentLeft;
    _textPage.font = [UIFont systemFontOfSize:8];
    _textPage.textColor = [UIColor whiteColor];
    [self addSubview:_textPage];
    
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    _textPage.textAlignment = _numberOfPages > 9 ? NSTextAlignmentRight : NSTextAlignmentCenter;
    NSMutableAttributedString *info = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%-2ld",(long)_currentPage+1] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:10]}];
    [info appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld",(long)_numberOfPages]]];
    _textPage.attributedText = info;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height/2;
}

@end
