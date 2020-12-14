//
//  MedLiveSendMsgRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveSendMsgRequest.h"

@implementation MedLiveSendMsgRequest
{
    NSString *_mobile;
}

- (instancetype)initWithMobile:(NSString *)mobile{
    self = [super init];
    if (self) {
        _mobile = mobile;
    }
    return self;
}

- (RequestMethodType)requestMethod{
    return RequestMethodTypeGET;
}

- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/api/send_sms?mobile=%@",_mobile];
}

- (void)sendMessageSuccess:(void(^)(NSString * code)) complateBlock fail:(void(^)(NSString *)) errorBlock{
    [self startRequestCompletionWithSuccess:^(MedLiveSendMsgRequest * request) {
        id obj = [request.responseObject valueForKey:@"data"];
        NSString *code = [[obj valueForKey:@"code"] stringValue];
        complateBlock(code);
    } failure:^(MedLiveSendMsgRequest* request) {
        errorBlock(@"短信发送失败");
    }];
}

- (void)dealloc{
    NSLog(@"");
}
@end
