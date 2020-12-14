//
//  IMManager.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "IMManager.h"
#import "AgoraCenter.h"
#import "MedRtmTokenRequest.h"

@interface IMManager()<AgoraRtmDelegate>
@property (readonly) AgoraRtmKit *rtmEngine;
@end

@implementation IMManager
{
    
}
static IMManager *manager = nil;
+ (id)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rtmEngine = [[AgoraRtmKit alloc] initWithAppId:[AgoraCenter appId] delegate:self];
    }
    return self;
}

- (void)loginToAgoraServiceWithId:(NSString *)userId{
    MedRtmTokenRequest *request = [[MedRtmTokenRequest alloc] initWithUid:userId];
    [request startWithSucBlock:^(NSString * _Nonnull token) {
        [self.rtmEngine loginByToken:token user:userId completion:^(AgoraRtmLoginErrorCode errorCode) {
            //登录结果
            if (errorCode == 0) {
                NSLog(@"成功登录聊天系统");
                [[NSNotificationCenter defaultCenter] postNotificationName:MedRtmRejoinCall object:nil];
            }else if (errorCode == AgoraRtmLoginErrorAlreadyLogin){
                [self.rtmEngine logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
                    [self loginToAgoraServiceWithId:userId];
                }];
            }
        }];
    }];
}

- (AgoraRtmChannel*)createChannelWithId:(NSString *)channelId ChannelDelegate:(id<AgoraRtmChannelDelegate>)delegate{
    return [self.rtmEngine createChannelWithId:channelId delegate:delegate];
}

- (BOOL)destroyChannel:(NSString *)channelId{
    return [self.rtmEngine destroyChannelWithId:channelId];
}

- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason{
    NSLog(@"RTM连接状态发生改变");
}

- (void)rtmKitTokenDidExpire:(AgoraRtmKit *)kit{
    NSLog(@"RTM Token已过期");
}

- (void)rtmKit:(AgoraRtmKit *)kit PeersOnlineStatusChanged:(NSArray<AgoraRtmPeerOnlineStatus *> *)onlineStatus{
    NSLog(@"友人 在线状态改变回调");
}

- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId{
    NSLog(@"收到消息：%@,来自:%@",message.text,peerId);
}

- (void)rtmKit:(AgoraRtmKit *)kit imageMessageReceived:(AgoraRtmImageMessage *)message fromPeer:(NSString *)peerId{
    NSLog(@"收到图片消息，来自：%@",peerId);
}


#pragma AgoraRtmDelegate Imp


#pragma AgoraRtmChannelDelegate Imp
@end
