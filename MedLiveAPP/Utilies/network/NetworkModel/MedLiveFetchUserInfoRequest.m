//
//  MedLiveFetchUserInfoRequest.m
//  MedLiveAPP
//
//  Created by zxt on 2020/12/15.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveFetchUserInfoRequest.h"

@implementation MedLiveFetchUserInfoRequest
{
    id param;
}

- (instancetype)initWithUid:(NSString *)uid
{
    self = [super init];
    if (self) {
        param = [NSDictionary dictionaryWithObject:uid forKey:@"user_id"];
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
    return @"/api/get_user_info";
}

- (void)fetchInfo:(void(^)(NSDictionary *))res{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest *request) {
        NSDictionary *dic = (NSDictionary *)request.responseObject;
        NSDictionary *userDic = [[dic objectForKey:@"data"] objectForKey:@"user_info"];
        if(userDic){
            res(userDic);
        }
    } failure:^(__kindof MedBaseRequest *request) {
        
    }];
}

@end
