//
//  MedLiveRoomMeetting.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoomMeetting.h"

@implementation MedLiveRoomMeetting
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    NSDictionary *dic = [super modelCustomPropertyMapper];
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    [mutableDic setValue:@"pwd" forKey:@"password"];
    [mutableDic setValue:@"is_upload_doc" forKey:@"allowDoc"];
    [mutableDic setValue:@"resource" forKey:@"docsJson"];
    return [mutableDic copy];
}
@end
