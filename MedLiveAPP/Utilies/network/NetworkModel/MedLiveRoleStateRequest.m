//
//  MedLiveRoleStateRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/26.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoleStateRequest.h"

@implementation MedLiveRoleStateRequest
{
    MedLiveRoleState roleState;
    id param;
}

- (instancetype)initWithState:(MedLiveRoleState)state RoomId:(NSString *)roomId Uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        roleState = state;
        param = [NSDictionary dictionaryWithObjectsAndKeys:roomId,@"room_id",
                                                           uid,@"user_id",nil];
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
    NSString *url;
    if (roleState == MedLiveRoleStateJoin) {
        url = @"/api/join_room";
    }else{
        url = @"/api/leave_room";
    }
    return url;
}

- (void)requestRoleState:(void(^)(void)) success{
    [self startRequestCompletionWithSuccess:^(MedLiveRoleStateRequest * request) {
        success();
    } failure:^(MedLiveRoleStateRequest * request) {
        
    }];
}
@end
