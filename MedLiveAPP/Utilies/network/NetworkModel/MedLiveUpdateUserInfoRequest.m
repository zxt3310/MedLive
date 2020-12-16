//
//  MedLiveUpdateUserInfoRequest.m
//  MedLiveAPP
//
//  Created by zxt on 2020/12/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveUpdateUserInfoRequest.h"

@implementation MedLiveUpdateUserInfoRequest
{
    NSString *name;
    NSString *url;
    NSString *uid;
}

- (instancetype)initWithName:(NSString *)name Uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self->name = name;
        self->uid = uid;
    }
    return self;
}

- (instancetype)initWithHeaderUrl:(NSString *)url Uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self->url = url;
        self->uid = uid;
    }
    return self;
}

- (id)requestArgument{
    NSMutableDictionary *argu = [NSMutableDictionary dictionary];
    [argu setValue:uid forKey:@"user_id"];
    [argu setValue:name forKey:@"true_name"];
    [argu setValue:url forKey:@"cover_pic"];
    return [argu copy];
}

- (NSString *)requestUrl{
    return @"/api/update_user_info";
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypePOST;
}

- (void)startUpdate:(void(^)(void)) res{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest *request) {
        res();
    } failure:^(__kindof MedBaseRequest *request) {
        
    }];
}

@end
