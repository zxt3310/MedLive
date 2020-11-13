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

- (void)setRole:(AgoraClientRole)role{
    _role = role;
    [_agorEngine setClientRole:role];
}

- (AgoraClientRole)role{
    return _role;
}

- (void)settingEnvtype:(MedLiveType) type{
    if (type == MedLiveTypeBordcast) {
        [_agorEngine setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    }else if (type == MedLiveTypeMeetting){
        [_agorEngine setChannelProfile:AgoraChannelProfileCommunication];
    }
}

- (void)setupVideoLocalView:(__kindof LiveView *) view{
    AgoraRtcVideoCanvas *localCanvas = [[AgoraRtcVideoCanvas alloc] init];
    localCanvas.uid = view.uid;
    localCanvas.view = view.videoView;
    view.videoCanvas = localCanvas;
    [self.agorEngine setupLocalVideo:localCanvas];
}

- (void)setupVideoRemoteView:(__kindof LiveView *)view{
    AgoraRtcVideoCanvas *remoteArea = [[AgoraRtcVideoCanvas alloc] init];
    remoteArea.uid = view.uid;
    view.videoCanvas = remoteArea;
    remoteArea.view = view.videoView;
    [self.agorEngine setupRemoteVideo:remoteArea];
}

- (void)enableVideo{
    [self.agorEngine enableVideo];
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
//- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
//    if(self.provideDelegate){
//        [self.provideDelegate didAddRemoteMember:uid];
//    }
//}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteStateReason)reason elapsed:(NSInteger)elapsed{
    if(self.provideDelegate && state == AgoraVideoRemoteStateStopped){
        [self.provideDelegate didRemoteLeave:uid];
    }
}

//- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
//    if(self.provideDelegate && self.role == AgoraClientRoleAudience){
//        [self.provideDelegate didAddRemoteMember:uid];
//    }
//}


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
