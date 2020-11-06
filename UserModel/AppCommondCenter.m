//
//  AppCommondCenter.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/5.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AppCommondCenter.h"

@implementation AppCommondCenter

static AppCommondCenter *center = nil;

+ (id)sharedCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[[self class] alloc] init];
    });
    return center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentUser = [[MedLiveUserModel alloc] init];
    }
    return self;
}

@end
