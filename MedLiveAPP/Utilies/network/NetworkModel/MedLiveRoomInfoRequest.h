//
//  MedLiveRoomInfoRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"
#import "MedLiveRoom.h"
NS_ASSUME_NONNULL_BEGIN

@interface MedLiveRoomInfoRequest : MedBaseRequest
- (instancetype)initWithRoomId:(NSString *)room;
- (void)fetchWithComplete:(void(^)(__kindof MedLiveRoom* room))success;
@end

NS_ASSUME_NONNULL_END
