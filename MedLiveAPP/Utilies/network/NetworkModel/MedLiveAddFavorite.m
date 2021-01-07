//
//  MedLiveAddFavorite.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/7.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedLiveAddFavorite.h"

@implementation MedLiveAddFavorite
{
    id param;
}

- (instancetype)initWithUid:(NSString *)uid RoomId:(NSString *)roomId
{
    self = [super init];
    if (self) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"user_id",roomId,@"room_id",nil];
        
    }
    return self;
}

- (RequestMethodType)requestMethod{
    return  RequestMethodTypePOST;
}

- (id)requestArgument{
    return param;
}

- (NSString *)requestUrl{
    return @"/api/add_favorite";
}

- (void)addFavorWithSuccess:(void(^)(void))success{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest * _Nonnull request) {
        success();
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        
    }];
}

@end


@implementation MedLiveRemoveFavorite
{
    id param;
}

- (instancetype)initWithUid:(NSString *)uid RoomId:(NSString *)roomId
{
    self = [super init];
    if (self) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"user_id",roomId,@"room_id",nil];
        
    }
    return self;
}

- (RequestMethodType)requestMethod{
    return  RequestMethodTypePOST;
}

- (id)requestArgument{
    return param;
}

- (NSString *)requestUrl{
    return @"/api/cancel_favorite";
}

- (void)removeFavorWithSuccess:(void(^)(void))success{
    [self startRequestCompletionWithSuccess:^(__kindof MedBaseRequest * _Nonnull request) {
        success();
    } failure:^(__kindof MedBaseRequest * _Nonnull request) {
        
    }];
}
@end
