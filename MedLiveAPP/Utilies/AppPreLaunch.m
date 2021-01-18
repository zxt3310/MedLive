//
//  AppPreLaunch.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AppPreLaunch.h"
#import "MedLiveNetManager.h"
#import "IMManager.h"

@implementation AppPreLaunch

+ (void)preparBeforUI{
    [MedLiveNetManager setBaseUrl:Domain];
    [[IMManager sharedManager] loginToAgoraServiceWithId:[AppCommondCenter sharedCenter].currentUser.uid];
    
    //每次启动时如果已登录，刷新 user info
    MedLiveUserModel *user = [AppCommondCenter sharedCenter].currentUser;
    if ([AppCommondCenter sharedCenter].hasLogin) {
        [[AppCommondCenter sharedCenter] fetchUserInfo:user.uid];
    }
}

@end
