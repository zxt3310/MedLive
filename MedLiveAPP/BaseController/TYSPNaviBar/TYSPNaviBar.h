//
//  TYSPNaviBar.h
//  TYSalePlatForm
//
//  Created by zhangxintao on 2019/6/6.
//  Copyright © 2019 zhangxintao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^popCall)(void);
typedef void(^rightItemCall)(void);	

@interface TYSPNaviBar : FlexFrameView

@property popCall shouldPop;

@property rightItemCall rightCall;

@property (nonatomic) NSString *title;

@property (nonatomic) UIColor *naviColor;

//设置右侧按钮
- (void)setRightItemImg:(UIImage *)img;
- (void)setRightItemText:(NSString *)text;

@end


