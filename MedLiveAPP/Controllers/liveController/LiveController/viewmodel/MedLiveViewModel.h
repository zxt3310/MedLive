//
//  MedLiveViewModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MedLiveRoomBoardcast;
@interface MedLiveViewModel : NSObject
- (void)setupLocalView:(__kindof UIView *)view;
- (int)joinChannel:(NSString *)channelName Token:(NSString *)token;
- (void)createRoomWithTitle:(NSString *)title ChannelId:(NSString *)channelId Complate:(void(^)(NSString *chanlToken))complateBlock;
- (void)sendLiveState:(MedLiveRoomState)state RoomId:(NSString *)roomId UserId:(NSString *)uid;
- (void)stopLive;
- (void)fetchRoomInfo:(NSString *)roomId Complete:(void(^)(MedLiveRoomBoardcast* ))res;
@end

NS_ASSUME_NONNULL_END
