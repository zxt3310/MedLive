//
//  AppCommondCenter.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/5.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AppCommondCenter.h"
#import "MedLiveFetchUserInfoRequest.h"

NSString *const RTCEngineDidReceiveMessage = @"RTCEngineDidReceiveMessage";
NSString *const RTMEngineDidReceiveSignal = @"RTMEngineDidReceiveSignal";
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
        if (self.hasLogin) {
            [self fetchUserInfo:self.currentUser.uid];
        }
    }
    return self;
}

- (void)updateUserInfo:(MedLiveUserModel *)newUser{
    self.currentUser = newUser;
    [newUser save];
}

- (void)loginWithMobile:(NSString *)mobile Uid:(NSString *)uid{
    [self fetchUserInfo:uid];
    self.hasLogin = YES;
    
    NSLog(@"登录成功 mobile:%@ uid:%@",mobile, uid);
}

- (void)fetchUserInfo:(NSString *)uid{
    MedLiveFetchUserInfoRequest *req = [[MedLiveFetchUserInfoRequest alloc] initWithUid:uid];
    [req fetchInfo:^(NSDictionary * infoDic) {
        MedLiveUserModel *user = [[MedLiveUserModel alloc] init];
        [user setWithDictionary:infoDic];
        self.currentUser = user;
        [self.currentUser save];
    }];
}

- (void)logout{
    self.currentUser = [[MedLiveUserModel alloc] init];
    self.hasLogin = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOCALUSERINFO_STORAGE_KEY];
}
@end
