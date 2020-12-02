//
//  AppCommondCenter.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/5.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AppCommondCenter.h"

NSString *const RTCEngineDidReceiveMessage = @"RTCEngineDidReceiveMessage";
NSString *const MedLoginCall = @"MedAppShouldPresentLoginController";
NSString *const MedRtmRejoinCall = @"MedRtmChannelRejoin";

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
        self.currentUser = [MedLiveUserModel loadFromUserDefaults];
        self.hasLogin = ![self.currentUser.uid isEqualToString:@"0"];
    }
    return self;
}

- (void)loginWithMobile:(NSString *)mobile Uid:(NSString *)uid Name:(NSString *)username{
    self.currentUser.mobile = mobile;
    self.currentUser.uid = uid;
    self.currentUser.userName = username;
    self.hasLogin = YES;
    
    [self.currentUser save];
    
    NSLog(@"登录成功 mobile:%@ uid:%@",mobile, uid);
}

@end
