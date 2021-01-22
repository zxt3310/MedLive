//
//  MedLiveHistoryMsgRequest.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/20.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedLiveHistoryMsgRequest.h"
#import "AgoraCenter.h"
#import "IMManager.h"

@implementation MedLiveHistoryMsgRequest
{
    NSString *channelId;
}

- (instancetype)initWithChannelId:(NSString *)Id
{
    self = [super init];
    if (self) {
        channelId = Id;
    }
    return self;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"https://api.agora.io/dev/v2/project/%@/rtm/message/history/query",[AgoraCenter appId]];
}

- (BOOL)withBaseUrl{
    return NO;
}

- (NSDictionary *)requestHeader{
    return @{
        @"x-agora-token":[IMManager sharedManager].rtmToken,
        @"x-agora-uid":[AppCommondCenter sharedCenter].currentUser.uid
    };
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypePOST;
}

- (id)requestArgument{
    return @{
        @"filter":@{
            @"destination":channelId,
            @"start_time":[self getUTCTime:[NSDate dateWithTimeIntervalSinceNow:-3600*24*6]],
            @"end_time":[self getUTCTime:[NSDate date]]
        },
        @"limit":[NSNumber numberWithInt:50]
    };
}

- (NSString *)getUTCTime:(NSDate *)date{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formater.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    return [formater stringFromDate:date];
}

- (void)startRequest:(void(^)(NSString *))handle{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest * _Nonnull request) {
        id obj = request.responseObject;
        NSString *location = [obj valueForKey:@"location"];
        if (location) {
            NSArray *paths = [location componentsSeparatedByString:@"/"];
            handle([paths lastObject]);
        }
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        
    }];
}
@end
