//
//  IMManager.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "IMManager.h"
#import "AgoraCenter.h"

@interface IMManager()<AgoraRtmDelegate,AgoraRtmChannelDelegate>
@property (readonly) AgoraRtmKit *rtmEngine;
@end

@implementation IMManager
static IMManager *manager = nil;
+ (id)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rtmEngine = [[AgoraRtmKit alloc] initWithAppId:[AgoraCenter appId] delegate:self];
    }
    return self;
}

- (void)loginToAgoraServiceWithId:(NSString *)userId Token:(NSString *)token{
    [self.rtmEngine loginByToken:@"006269ff1d0fecd46b783132c2bda90fc66IAB7R5aFUjAgB4KW1B4/K4yLcQIQDAq1TrFEy7G/SYqqDtJjSIgAAAAAEABO10qJWLqjXwEAAQBYuqNf" user:userId completion:^(AgoraRtmLoginErrorCode errorCode) {
        //登录结果
        
    }];
}
@end
