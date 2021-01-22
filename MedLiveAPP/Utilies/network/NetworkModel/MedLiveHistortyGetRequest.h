//
//  MedLiveHistortyGetRequest.h
//  MedLiveAPP
//
//  Created by zxt on 2021/1/20.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveHistortyGetRequest : MedBaseRequest
- (instancetype)initWithHandle:(NSString *)handleStr;
- (void)startRequestWithComplate:(void(^)(NSArray *))comlete;
@end

NS_ASSUME_NONNULL_END
