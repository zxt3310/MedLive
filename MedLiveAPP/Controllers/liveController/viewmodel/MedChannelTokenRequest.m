//
//  MedChannelTokenRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedChannelTokenRequest.h"

@implementation MedChannelTokenRequest
{
    NSString *roomId;
    NSString *uid;
}

- (instancetype)initWithRoomId:(NSString *)channelId Uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        roomId = channelId;
        self->uid = uid;
    }
    return self;
}


- (RequestMethodType)requestMethod{
    return RequestMethodTypeGET;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/api/fetch-agora-token/%@/%@",roomId,uid];
}

- (void)startWithSucBlock:(void(^)(NSString *token)) block{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest * _Nonnull request) {
        NSDictionary *dic = request.responseObject;
        block(dic[@"data"][@"token"]);
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        
    }];
}

@end
