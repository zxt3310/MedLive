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
    return [NSDictionary dictionaryWithObjectsAndKeys:uid,@"user_id",name,@"true_name",url,@"cover_pic", nil];
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
