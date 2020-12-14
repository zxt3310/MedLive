//
//  MedLiveSendMsgRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveSendMsgRequest : MedBaseRequest
- (instancetype)initWithMobile:(NSString * _Nonnull)mobile;
- (void)sendMessageSuccess:(void(^)(NSString * code)) complateBlock fail:(void(^)(NSString *)) errorBlock;
@end

NS_ASSUME_NONNULL_END
