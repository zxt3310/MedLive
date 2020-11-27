//
//  MedChannelStateRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/8.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedChannelStateRequest.h"

@implementation MedChannelStateRequest
{
    MedLiveRoomState roomState;
    id param;
}

- (instancetype)initWithState:(MedLiveRoomState)state RoomId:(NSString *)roomId Uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        roomState = state;
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
    if (roomState == MedLiveRoomStateStart) {
        url = @"/api/start_room";
    }else{
        url = @"/api/close_room";
    }
    return url;
}

- (void)requestRoomState:(void(^)(void)) success{
    [self startRequestCompletionWithSuccess:^(MedChannelStateRequest * request) {
        success();
    } failure:^(MedChannelStateRequest * request) {
        
    }];
}
@end
