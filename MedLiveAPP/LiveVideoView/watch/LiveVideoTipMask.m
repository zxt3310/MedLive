//
//  LiveVideoTipMask.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/7.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "LiveVideoTipMask.h"

@implementation LiveVideoTipMask
{
    UILabel *tipLabel;
    UIView *countView;
    UILabel *countLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //遮罩
        UIView *mask = [[UIView alloc] init];
        mask.backgroundColor = [UIColor ColorWithRGB:5 Green:5 Blue:5 Alpha:0.3];
        [self addSubview: mask];
        //非倒计时提示语
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = [UIFont systemFontOfSize:16];
        tipLabel.hidden = YES;
        [mask addSubview:tipLabel];
        
        //倒计时view
        countView = [[UIView alloc] init];
        countView.hidden = YES;
        [mask addSubview:countView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"距离开播还剩";
        [mask addSubview:titleLabel];
        
        countLabel = [[UILabel alloc] init];
        countLabel.textColor = [UIColor whiteColor];
        [mask addSubview:countLabel];
        
        
        
    }
    return self;
}

@end
