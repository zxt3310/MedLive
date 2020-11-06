//
//  MedLiveLoginRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/28.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveLoginRequest : MedBaseRequest
- (instancetype)initWithMobile:(NSString *)mobile Code:(NSString *)code;
- (void)requestLogin:(void(^)(id userInfo)) complateBlock;
@end

NS_ASSUME_NONNULL_END
