//
//  MedLiveRoleStateRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/26.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveRoleStateRequest : MedBaseRequest
- (instancetype)initWithState:(MedLiveRoleState)state RoomId:(NSString *)roomId Uid:(NSString *)uid;
- (void)requestRoleState:(void(^)(void)) success;
@end

NS_ASSUME_NONNULL_END
