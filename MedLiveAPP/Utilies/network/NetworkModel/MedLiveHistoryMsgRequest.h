//
//  MedLiveHistoryMsgRequest.h
//  MedLiveAPP
//
//  Created by zxt on 2021/1/20.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveHistoryMsgRequest : MedBaseRequest
- (instancetype)initWithChannelId:(NSString *)Id;
- (void)startRequest:(void(^)(NSString *))handle;
@end

NS_ASSUME_NONNULL_END
