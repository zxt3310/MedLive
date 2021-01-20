//
//  MedLiveHistortyGetRequest.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/20.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedLiveHistortyGetRequest.h"
#import "AgoraCenter.h"

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
@end
