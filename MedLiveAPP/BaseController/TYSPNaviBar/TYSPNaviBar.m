//
//  TYSPNaviBar.m
//  TYSalePlatForm
//
//  Created by zhangxintao on 2019/6/6.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import "TYSPNaviBar.h"

@implementation TYSPNaviBar
{
    UIView *_barView;
    UILabel *_titleLb;
    UIImageView *_rightItemView;
    UILabel *_rightItemLb;
}
@synthesize title = _title;
@synthesize naviColor = _naviColor;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self enableFlexLayout:YES];
        self.flexibleHeight = YES;
    }
    return self;
}

- (void)onInit{
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLb.text = title;
}

- (void)setNaviColor:(UIColor *)naviColor{
    _naviColor = naviColor;
    self.backgroundColor = naviColor;
}

- (void)popView{
    if (self.shouldPop) {
        self.shouldPop();
    }
}

- (void)rightItemAction{
    if (self.rightCall) {
        self.rightCall();
    }
}

- (void)setRightItemImg:(UIImage *)img{
    _rightItemView.image = img;
}

- (void)setRightItemText:(NSString *)text{
    _rightItemLb.text = text;
}

@end
