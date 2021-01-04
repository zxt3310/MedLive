//
//  AppCommondCenter.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/5.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AppCommondCenter.h"
#import "MedLiveFetchUserInfoRequest.h"
#import "IMManager.h"
#import <YYModel.h>

NSString *const RTMEngineDidReceiveMessage = @"RTMEngineDidReceiveMessage";
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
    
    //更新RTM 属性
    NSString *userName = KIsBlankString(newUser.userName)?newUser.uid:newUser.userName;
    NSString *headerUrl = Kstr(newUser.headerImgUrl);
    [[IMManager sharedManager] setLocalUserAttrbuteWithName:userName Headerpic:[NSString stringWithFormat:@"%@%@",Cdn_domain,headerUrl]];
}

- (void)loginWithUid:(NSString *)uid{
    //拉取用户信息
    [self fetchUserInfo:uid];
    self.hasLogin = YES;
    
    //登录聊天系统
    [[IMManager sharedManager] loginToAgoraServiceWithId:uid];
    
    NSLog(@"登录成功 uid:%@", uid);
}

- (void)fetchUserInfo:(NSString *)uid{
    MedLiveFetchUserInfoRequest *req = [[MedLiveFetchUserInfoRequest alloc] initWithUid:uid];
    [req fetchInfo:^(NSDictionary * infoDic) {
        MedLiveUserModel *user = [MedLiveUserModel yy_modelWithDictionary:infoDic];
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
