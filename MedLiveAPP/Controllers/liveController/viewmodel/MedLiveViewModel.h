//
//  MedLiveViewModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveViewModel : NSObject

- (void)setupLocalView:(__kindof UIView *)view;
- (int)joinChannel:(NSString *)channelName Token:(NSString *)token;
- (void)createRoomWithTitle:(NSString *)title Description:(NSString *)desc Complate:(void(^)(NSString* chanlId, NSString *chanlToken, NSString *roomID))complateBlock;
- (void)stopLive;
@end

NS_ASSUME_NONNULL_END
