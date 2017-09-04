//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
#define defaultWidth self.frame.size.width //默认label的宽度 超过则滚动
#define defaultInterval 3.5 //默认时间间隔
#define delayInterval 1.0 //先定一段时间 延迟滚动

@implementation SDCollectionViewCell{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, self.frame.size.height)];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    _titleLabel.numberOfLines = 1;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"%@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
    
    if (self.textScrollEnable ) {
        CGFloat width = [self boundingWidthWithString:_titleLabel.text withFont:_titleLabelTextFont withMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        _titleLabel.frame = CGRectMake(0, 0, width, self.frame.size.height);
        
        [UIView animateWithDuration:defaultInterval delay:delayInterval options:UIViewAnimationOptionTransitionNone animations:^{
            if (width>defaultWidth) {
                _titleLabel.frame = CGRectMake(defaultWidth-width, 0, width, self.frame.size.height);
            }
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)setAttributeTitle:(NSAttributedString *)attributeTitle {
    _attributeTitle = [attributeTitle copy];
    if ([attributeTitle isKindOfClass:[NSAttributedString class]]) {
        _titleLabel.attributedText = attributeTitle;
    }
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
    
    if (self.textScrollEnable ) {
        CGFloat width = [self boundingWidthWithString:_titleLabel.text withFont:_titleLabelTextFont withMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        _titleLabel.frame = CGRectMake(0, 0, width, self.frame.size.height);
        
        [UIView animateWithDuration:defaultInterval delay:delayInterval options:UIViewAnimationOptionTransitionNone animations:^{
            if (width>defaultWidth) {
                _titleLabel.frame = CGRectMake(defaultWidth-width, 0, width, self.frame.size.height);
            }
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        CGFloat width = [self boundingWidthWithString:_titleLabel.text withFont:_titleLabelTextFont withMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        CGRect frame = _titleLabel.frame;
        frame.size = CGSizeMake(width, self.frame.size.height);
        _titleLabel.frame = frame;
        
    } else {
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.sd_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
    
}

-(CGSize)boundingWidthWithString:(NSString *)string withFont:(UIFont *)Font withMaxSize:(CGSize)MaxSize
{
    CGRect rect = [string boundingRectWithSize:MaxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font} context:nil];
    return  rect.size;
}

@end
