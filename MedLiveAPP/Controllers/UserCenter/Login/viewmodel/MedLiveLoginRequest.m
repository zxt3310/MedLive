//
//  MedLiveLoginRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/28.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveLoginRequest.h"

@implementation MedLiveLoginRequest
{
    id param;
}

- (instancetype)initWithMobile:(NSString *)mobile Code:(NSString *)code
{
    self = [super init];
    if (self) {
        param = @{
            @"mobile":mobile,
            @"code":code
        };
    }
    return self;
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypePOST;
}

- (NSString *)requestUrl{
    return @"/api/login";
}

- (id)requestArgument{
    return param;
}

- (void)requestLogin:(void(^)(id userInfo)) complateBlock;{
    [self startRequestCompletionWithSuccess:^(MedLiveLoginRequest * request) {
        id obj = request.responseObject;
        id user = [obj valueForKey:@"data"];
        complateBlock(user);
    } failure:^(MedLiveLoginRequest* request) {
        
    }];
}

- (void)dealloc{
    
}

@end
