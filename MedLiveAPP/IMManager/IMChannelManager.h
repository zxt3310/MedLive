//
//  IMChannelManager.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMManager.h"
NS_ASSUME_NONNULL_BEGIN

@protocol IMChannelDelegate <NSObject>
@required
- (void)channelDidReceiveMessage:(AgoraRtmMessage *)message;


@optional
@end

@interface IMChannelManager : NSObject
@property AgoraRtmChannel *imChannel;
- (instancetype)initWithId:(NSString *)channelId;
- (void)rtmJoinChannel;
- (void)leaveChannel;
- (void)sendRawMessage:(NSData *)msgData Completion:(void(^)(void)) success;
@end

NS_ASSUME_NONNULL_END
