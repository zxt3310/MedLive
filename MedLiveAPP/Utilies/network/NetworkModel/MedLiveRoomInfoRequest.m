//
//  MedLiveRoomInfoRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoomInfoRequest.h"
#import "MedLiveRoomBoardcast.h"
#import "MedLiveRoomConsultation.h"
#import "MedLiveRoomMeetting.h"

@implementation MedLiveRoomInfoRequest
{
    NSString *roomId;
}

- (instancetype)initWithRoomId:(NSString *)room
{
    self = [super init];
    if (self) {
        roomId = room;
    }
    return self;
}

- (id)requestArgument{
    return @{@"room_id":roomId};
}
- (RequestMethodType)requestMethod{
    return RequestMethodTypePOST;
}

- (NSString *)requestUrl{
    return @"/api/get_room_info";
}

- (void)fetchWithComplete:(void(^)(__kindof MedLiveRoom* room))success{
    [self startRequestCompletionWithSuccess:^(MedLiveRoomInfoRequest *request) {
        NSDictionary *dic = request.responseObject;
        id obj = dic[@"data"][@"room_info"];
        NSString *type = obj[@"type"];
        MedLiveRoom *liveRoom;
        if ([type isEqualToString:@"boardcast"])
        {
            liveRoom = [MedLiveRoomBoardcast yy_modelWithDictionary:obj];
        }else if([type isEqualToString:@"meeting"])
        {
            liveRoom = [MedLiveRoomMeetting yy_modelWithDictionary:obj];
        }else
        {
            liveRoom = [MedLiveRoomConsultation yy_modelWithDictionary:obj];
        }
        
        if (liveRoom) {
            success(liveRoom);
        }
    } failure:^(MedLiveRoomInfoRequest *request) {
        
    }];
}
@end
