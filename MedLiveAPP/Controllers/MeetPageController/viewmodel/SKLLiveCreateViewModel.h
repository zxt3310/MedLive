//
//  SKLLiveCreateViewModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/6.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKLLiveCreateViewModel : NSObject
- (void)createLivePlanWithTitle:(NSString *)title Desc:(NSString *)description Uid:(NSString *)uid Start:(NSString *)start picUrl:(NSString *)url Complete:(void(^)(NSString *channelId,NSString *title,NSString *roomId))success;
@end

NS_ASSUME_NONNULL_END
