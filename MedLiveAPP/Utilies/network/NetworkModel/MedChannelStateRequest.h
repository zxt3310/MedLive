//
//  MedChannelStateRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/8.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedChannelStateRequest : MedBaseRequest
- (instancetype)initWithState:(MedLiveRoomState)state RoomId:(NSString *)roomId Uid:(NSString *)uid;
- (void)requestRoomState:(void(^)(void)) success;
@end

NS_ASSUME_NONNULL_END
