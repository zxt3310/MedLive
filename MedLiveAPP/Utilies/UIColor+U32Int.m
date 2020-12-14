//
//  UIColor+U32Int.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "UIColor+U32Int.h"

@implementation UIColor(U32Int)

+ (UIColor *)ColorWithRGB:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)ColorFromHex:(int)s{
    return [UIColor colorWithRed:(((s &0xFF0000) >>16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0];
}

@end
