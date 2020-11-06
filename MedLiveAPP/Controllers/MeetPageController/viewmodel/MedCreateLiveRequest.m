//
//  MedCreateLiveRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedCreateLiveRequest.h"

@implementation MedCreateLiveRequest
{
    id param;
}

- (instancetype)initWithTitle:(NSString *)title Desc:(NSString *)description Uid:(NSString *)uid Start:(NSString *)start picUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        param = @{
            @"name":title,
            @"desc":description,
            @"user_id":uid,
            @"begin_time":start,
            @"cover_pic":@""
        };
    }
    return self;
}

- (id)requestArgument{
    return param;
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypePOST;
}

- (NSString *)requestUrl{
    return @"/api/create_conference";
}

- (void)startWithSucBlock:(void(^)(NSString *channelId,NSString *title,NSString *roomId)) block{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest * _Nonnull request) {
        NSDictionary *dic = request.responseObject;
        NSString *chel = dic[@"data"][@"channel_id"];
        NSString *room = dic[@"data"][@"channel_name"];
        NSString *romId = dic[@"data"][@"room_id"];
        
        block(chel,room,romId);
        
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        NSLog(@"请求失败 URL:%@",request.response.URL.absoluteString);
    }];
}

@end
