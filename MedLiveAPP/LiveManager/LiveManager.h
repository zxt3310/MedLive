//
//  LiveManager.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/10.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "AgoraCenter.h"
#import "LiveVideoRenderView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LiveManagerRemoteCanvasProvideDelegate <NSObject>
@optional
- (void)didAddRemoteMember:(NSUInteger)uid;
- (void)didRemoteLeave:(NSInteger) uid;
- (void)didReceiveRemoteAudio:(NSArray <AgoraRtcAudioVolumeInfo*>*) speakers;
- (void)remote:(NSInteger)uid DidDisabledCamera:(BOOL)disable;
- (void)remoteBecomeActiveSpeaker:(NSInteger)uid;
@end

@interface LiveManager : NSObject
@property (nonatomic) AgoraClientRole role;
@property (weak) id<LiveManagerRemoteCanvasProvideDelegate> provideDelegate;
//设置使用场景
- (void)settingEnvtype:(MedLiveType) type;
//开启视频采集
- (int)enableVideo;
//关闭视频采集
- (int)disableVideo;
//关闭音频采集
- (int)disableAudio;
//加载本地流视图
- (void)setupVideoLocalView:(__kindof LiveView *) view;
//加入频道
- (int)joinRoomByToken:(NSString *)token Room:(NSString *)roomId Uid:(NSString *)uid success:(void(^)(void))success;
//加载远端流视图
- (void)setupVideoRemoteView:(UIView *)view;
//暂停、继续
- (MedLiveState)pauseOrPlay:(MedLiveState)stateBefore;
//离开频道
- (void)leaveRoom;
//开启发言监控
- (void)settingOpenVolumeIndication:(BOOL) open;
//本地静音
- (void)muteLocalMic:(BOOL)mute;
//制定远端流静音
- (void)muteRemoteMic:(NSInteger) uid Mute:(BOOL)mute;
//关闭本地摄像头
- (int)disableLocalCamera:(BOOL)disable;
//切换前置后置
- (void)switchCamera;
@end

NS_ASSUME_NONNULL_END
