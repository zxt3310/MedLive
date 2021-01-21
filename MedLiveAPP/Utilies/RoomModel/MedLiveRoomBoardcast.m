//
//  MedLiveRoomBoardcast.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoomBoardcast.h"

@implementation MedLiveRoomBoardcast

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    NSDictionary *dic = [super modelCustomPropertyMapper];
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    [mutableDic setValue:@"desc" forKey:@"desc"];
    [mutableDic setValue:@"cover_pic" forKey:@"coverPic"];
    [mutableDic setValue:@"introduce_pic" forKey:@"introPicsJosn"];
    [mutableDic setValue:@"ori_cloud_video_path" forKey:@"backVideoPath"];
    return [mutableDic copy];
}
@end
