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

+ (instancetype)sharedCenter{
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
        self.hasLogin = NO;
        self.currentUser = [[MedLiveUserModel alloc] init];
    }
    return self;
}

- (void)loginWithMobile:(NSString *)mobile Uid:(NSString *)uid Name:(NSString *)username{
    self.currentUser.mobile = mobile;
    self.currentUser.uid = uid;
    self.currentUser.userName = username;
    self.hasLogin = YES;
}

@end
