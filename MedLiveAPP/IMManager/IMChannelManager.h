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
@class MedChannelChatMessage;
@class MedChannelSignalMessage;
@protocol IMChannelDelegate <NSObject>
@required
- (void)channelDidReceiveMessage:(MedChannelChatMessage *)message;
- (void)channelDidReceiveSignal:(MedChannelSignalMessage *)signal;
- (void)channelDidChangeAttribute:(NSDictionary *)attribute;
@optional
@end

@interface IMChannelManager : NSObject
@property AgoraRtmChannel *imChannel;
@property (weak)id<IMChannelDelegate> channelDelegate;
- (instancetype)initWithId:(NSString *)channelId;
- (void)rtmJoinChannel;
- (void)rejoinChannel;
- (void)leaveChannel;
- (void)sendTextMessage:(NSString *)text Success:(void(^)(void))result;
- (void)sendRawMessage:(NSData *)msgData Completion:(void(^)(void)) success;
- (void)getChannelAttributes;
//获取所有人
- (void)TotalMembersOfChannel:(void(^)(NSArray <NSString*>* members))result;
@end

NS_ASSUME_NONNULL_END
