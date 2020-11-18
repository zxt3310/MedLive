//
//  MedChannelTokenRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedChannelTokenRequest : MedBaseRequest
- (instancetype)initWithRoomId:(NSString *)channelId Uid:(NSString *)uid;
- (void)startWithSucBlock:(void(^)(NSString *token)) block;
@end

NS_ASSUME_NONNULL_END
