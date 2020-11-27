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

- (instancetype)initWithTitle:(NSString *)title Desc:(NSString *)description Uid:(NSString *)uid Start:(NSString *)start picUrl:(NSString *)url Type:(NSString*) type Password:(NSString *)pwd AllowDoc:(BOOL)allow Docs:(NSString *)docs intrPics:(NSString *)pics
{
    self = [super init];
    if (self) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                                                title,@"name",
                                                description,@"desc",
                                                uid,@"user_id",
                                                start,@"begin_time",
                                                url,@"cover_pic",
                                                type,@"type",
                                                pwd,@"pwd",
                                                allow?@"1":@"0", @"is_upload_doc",
                                                allow?docs:@"",@"resource",
                                                pics,@"introduce_pic",
                                                nil];
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
        NSString *romId = [dic[@"data"][@"room_id"] stringValue];
        
        block(chel,room,romId);
        
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        NSLog(@"请求失败 URL:%@",request.response.URL.absoluteString);
    }];
}

@end
