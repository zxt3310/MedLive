//
//  MedLiveRoom.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoom.h"

@implementation MedLiveRoom

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"channelId":@"channel_id",
        @"roomId":@"id",
        @"type":@"type",
        @"startTime":@"begin_time",
        @"endTime":@"end_time",
        @"roomTitle":@"name",
        @"status":@"status",
        @"owner":@"creator_id"
    };
}
@end
