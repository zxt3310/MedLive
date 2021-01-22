//
//  MedLiveHistortyGetRequest.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/20.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedLiveHistortyGetRequest.h"
#import "AgoraCenter.h"
#import "IMManager.h"

@implementation MedLiveHistortyGetRequest
{
    NSString *handle;
}

- (instancetype)initWithHandle:(NSString *)handleStr
{
    self = [super init];
    if (self) {
        handle = handleStr;
    }
    return self;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"https://api.agora.io/dev/v2/project/%@/rtm/message/history/query/%@",[AgoraCenter appId],handle];
}

- (BOOL)withBaseUrl{
    return NO;
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypeGET;
}

- (NSDictionary *)requestHeader{
    return @{
        @"x-agora-token":[IMManager sharedManager].rtmToken,
        @"x-agora-uid":[AppCommondCenter sharedCenter].currentUser.uid
    };
}

- (void)startRequestWithComplate:(void(^)(NSArray *))comlete{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest * _Nonnull request) {
        id obj = request.responseObject;
        NSString *res = [obj valueForKey:@"code"];
        if (![res isEqualToString:@"ok"]) {
            [MedLiveAppUtilies showErrorTip:@"历史消息获取失败"];
            return;
        }
        
        NSArray *ary = [obj valueForKey:@"messages"];
        if (ary) {
            comlete(ary);
        }
        
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        
    }];
}

@end
