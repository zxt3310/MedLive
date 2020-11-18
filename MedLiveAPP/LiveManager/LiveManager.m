//
//  LiveManager.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/10.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveManager.h"


@interface LiveManager()<AgoraRtcEngineDelegate>
@property (readonly)AgoraRtcEngineKit *agorEngine;
@property BOOL isPlaying;
@end

@implementation LiveManager
{
    
}
@synthesize role = _role;
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册组件
        _agorEngine = [AgoraRtcEngineKit sharedEngineWithAppId:[AgoraCenter appId] delegate:self];
        //默认设置频道模式 AgoraChannelProfileCommunication 视频一对一通话  AgoraChannelProfileLiveBroadcasting 直播
        [_agorEngine setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    }
    return self;
}
//设置角色
- (void)setRole:(AgoraClientRole)role{
    _role = role;
    [_agorEngine setClientRole:role];
}

- (AgoraClientRole)role{
    return _role;
}
//设置使用场景
- (void)settingEnvtype:(MedLiveType) type{
    if (type == MedLiveTypeBordcast) {
        [_agorEngine setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    }else if (type == MedLiveTypeMeetting){
        [_agorEngine setChannelProfile:AgoraChannelProfileCommunication];
    }
}
//设置开启发言检测
- (void)settingOpenVolumeIndication:(BOOL) open{
    NSInteger interval = 0;
    interval = open?500:0;
    [self.agorEngine enableAudioVolumeIndication:interval smooth:2 report_vad:NO];
}
//加载本地流
- (void)setupVideoLocalView:(__kindof LiveView *) view{
    AgoraRtcVideoCanvas *localCanvas = [[AgoraRtcVideoCanvas alloc] init];
    localCanvas.uid = view.uid;
    localCanvas.view = view.videoView;
    view.videoCanvas = localCanvas;
    [self.agorEngine setupLocalVideo:localCanvas];
}
//加载远端流
- (void)setupVideoRemoteView:(__kindof LiveView *)view{
    AgoraRtcVideoCanvas *remoteArea = [[AgoraRtcVideoCanvas alloc] init];
    remoteArea.uid = view.uid;
    view.videoCanvas = remoteArea;
    remoteArea.view = view.videoView;
    [self.agorEngine setupRemoteVideo:remoteArea];
}
//启动本地视频采集
- (void)enableVideo{
    [self.agorEngine enableVideo];
}
//本地静音
- (void)muteLocalMic:(BOOL)mute{
    [self.agorEngine muteLocalAudioStream:mute];
}
//远端静音
- (void)muteRemoteMic:(NSInteger) uid Mute:(BOOL)mute{
    [self.agorEngine muteRemoteAudioStream:uid mute:mute];
}
//关闭本地摄像头
- (int)disableLocalCamera:(BOOL)disable{
    return [self.agorEngine enableLocalVideo:disable];
}
//前置后置摄像头
- (void)switchCamera{
    [self.agorEngine switchCamera];
}

- (int)joinRoomByToken:(NSString *)token Room:(NSString *)roomId Uid:(NSString *)uid{
    return [self.agorEngine joinChannelByToken:token
                                     channelId:roomId
                                          info:nil
                                           uid:uid.integerValue
                                   joinSuccess:^(NSString * channel, NSUInteger uid, NSInteger elapsed){
        NSLog(@"进入频道%@   用户:%ld",channel,uid);
    }];
}

- (void)leaveRoom{
    [self.agorEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        
    }];
}

//视频通话有远端用户进入（互相可见）
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    if(self.provideDelegate){
        [self.provideDelegate didAddRemoteMember:uid];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    
}

//远端视频状态改变 （失败 结束 延迟）
- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteStateReason)reason elapsed:(NSInteger)elapsed{
    //远端离线
    if(self.provideDelegate && (state == AgoraVideoRemoteStateStopped && reason == AgoraVideoRemoteStateReasonRemoteOffline)){
        [self.provideDelegate didRemoteLeave:uid];
    }
    
    //远端关闭摄像头
    if (self.provideDelegate && (state == AgoraVideoRemoteStateStopped && reason == AgoraVideoRemoteStateReasonRemoteMuted)) {
        NSLog(@"远端关闭摄像头");
    }
    
    //远端恢复摄像头
    if (self.provideDelegate && (state == AgoraVideoRemoteStateDecoding && reason == AgoraVideoRemoteStateReasonRemoteUnmuted)) {
        NSLog(@"远端恢复摄像头");
    }
    
    //远端网络堵塞
    if (self.provideDelegate && (state == AgoraVideoRemoteStateReasonNetworkCongestion)) {
        
    }
    
    //远端网络恢复
    if (self.provideDelegate && (state == AgoraVideoRemoteStateReasonNetworkRecovery)) {
        
    }
}
//远端用户发言音量回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo *> *)speakers totalVolume:(NSInteger)totalVolume{
    AgoraRtcAudioVolumeInfo *info = [speakers firstObject];
    if (info.uid !=0 && self.provideDelegate && [self.provideDelegate respondsToSelector:@selector(didReceiveRemoteAudio:)]) {
        [self.provideDelegate didReceiveRemoteAudio:speakers];
    }
}

- (MedLiveState)pauseOrPlay:(MedLiveState)stateBefore{
    if(stateBefore == MedLiveStatePlaying){
        int res = [_agorEngine muteAllRemoteVideoStreams:YES];
        if(!res){
            return MedLiveStatePausing;
        }
    }else if(stateBefore == MedLiveStatePausing){
        int res = [_agorEngine muteAllRemoteVideoStreams:NO];
        if(!res){
            return MedLiveStatePlaying;
        }
    }
    return stateBefore;
}


- (void)dealloc{
    [AgoraRtcEngineKit destroy];
    NSLog(@"agoraEngine destroy");
}

@end
