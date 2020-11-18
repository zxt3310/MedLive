//
//  MedRtmTokenRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedRtmTokenRequest.h"

@implementation MedRtmTokenRequest
{
    NSString *userId;
}

- (instancetype)initWithUid:(NSString *)uid
{
    self = [super init];
    if (self) {
        userId = uid;
    }
    return self;
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypeGET;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/api/fetch-agora-rtm-token/%@",userId];
}

- (void)startWithSucBlock:(void(^)(NSString *token)) block{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest * _Nonnull request) {
        NSDictionary *dic = request.responseObject;
        block(dic[@"data"][@"token"]);
        NSLog(@"token: %@",dic[@"data"][@"token"]);
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        
    }];
}

@end
