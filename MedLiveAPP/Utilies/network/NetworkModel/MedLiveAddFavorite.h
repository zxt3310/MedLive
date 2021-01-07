//
//  MedLiveAddFavorite.h
//  MedLiveAPP
//
//  Created by zxt on 2021/1/7.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveAddFavorite : MedBaseRequest
- (instancetype)initWithUid:(NSString *)uid RoomId:(NSString *)roomId;
- (void)addFavorWithSuccess:(void(^)(void))success;
@end

@interface MedLiveRemoveFavorite : MedBaseRequest
- (instancetype)initWithUid:(NSString *)uid RoomId:(NSString *)roomId;
- (void)removeFavorWithSuccess:(void(^)(void))success;
@end

NS_ASSUME_NONNULL_END
