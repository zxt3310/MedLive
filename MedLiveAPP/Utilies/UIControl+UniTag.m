//
//  UIControl+UniTag.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/27.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "UIControl+UniTag.h"
#import <objc/runtime.h>

@implementation UIView(unitag)

- (void)setUniTag:(NSString *)uniTag{
    objc_setAssociatedObject(self, @selector(uniTag), uniTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)uniTag{
    return objc_getAssociatedObject(self, _cmd);
}

@end
