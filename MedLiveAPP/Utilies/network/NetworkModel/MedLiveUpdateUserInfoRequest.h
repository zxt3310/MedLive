//
//  MedLiveUpdateUserInfoRequest.h
//  MedLiveAPP
//
//  Created by zxt on 2020/12/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveUpdateUserInfoRequest : MedBaseRequest
- (instancetype)initWithName:(NSString *)name Uid:(NSString *)uid;
- (instancetype)initWithHeaderUrl:(NSString *)url Uid:(NSString *)uid;
- (void)startUpdate:(void(^)(void)) res;
@end

NS_ASSUME_NONNULL_END
