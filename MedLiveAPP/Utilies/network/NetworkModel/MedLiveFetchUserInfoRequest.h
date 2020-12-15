//
//  MedLiveFetchUserInfoRequest.h
//  MedLiveAPP
//
//  Created by zxt on 2020/12/15.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveFetchUserInfoRequest : MedBaseRequest
- (instancetype)initWithUid:(NSString *)uid;
- (void)fetchInfo:(void(^)(NSDictionary *))res;
@end

NS_ASSUME_NONNULL_END
