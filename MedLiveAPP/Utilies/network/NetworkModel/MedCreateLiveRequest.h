//
//  MedCreateLiveRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedCreateLiveRequest : MedBaseRequest
- (instancetype)initWithTitle:(NSString *)title Desc:(NSString *)description Uid:(NSString *)uid Start:(NSString *)start picUrl:(NSString *)url Type:(NSString*) type Password:(NSString *)pwd AllowDoc:(BOOL)allow Docs:(NSString *)docs;
- (void)startWithSucBlock:(void(^)(NSString *channelId,NSString *title,NSString *roomId)) block;
@end

NS_ASSUME_NONNULL_END
