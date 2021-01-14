//
//  MedLiveRoomConsultation.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoomConsultation.h"

@implementation MedLiveRoomConsultation

@end

@implementation Patient

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"pId":@"id",
        @"cId":@"consultation_id",
        @"uId":@"user_id",
        @"sex":@"sex",
        @"age":@"age",
        @"name":@"name",
        @"resource":@"patient_resouce",
        @"symptom":@"symptom",
        @"roomId":@"room_id",
        @"createTime":@"created_at"
    };
}

@end
