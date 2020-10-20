//
//  UIColor+U32Int.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIColor(U32Int)
+ (UIColor *)ColorWithRGB:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha;
+ (UIColor *)ColorFromHex:(int)s;
@end

NS_ASSUME_NONNULL_END
