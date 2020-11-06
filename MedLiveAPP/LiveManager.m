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
    NSMutableArray<AgoraRtcVideoCanvas*> *areaCollection;
}
@synthesize role = _role;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setRole:(AgoraClientRole)role{
    if(self.agorEngine){
        _role = role;
        [self.agorEngine setClientRole:role];
    }else{
        _role = role;
        [self prepareToLive:role];
    }
}

- (AgoraClientRole)role{
    return _role;
}


- (void)prepareToLive:(AgoraClientRole) role{
    //注册组件
    _agorEngine = [AgoraRtcEngineKit sharedEngineWithAppId:[AgoraCenter appId] delegate:self];
    //设置频道模式 AgoraChannelProfileCommunication 视频一对一通话  AgoraChannelProfileLiveBroadcasting 直播
    [_agorEngine setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    //设置角色
    [_agorEngine setClientRole:role];
}

- (void)setupVideoLocalView:(__kindof LiveView *) view{
    AgoraRtcVideoCanvas *localCanvas = [[AgoraRtcVideoCanvas alloc] init];
    localCanvas.view = view.videoView;
    view.videoCanvas = localCanvas;
    [self.agorEngine setupLocalVideo:localCanvas];
    [areaCollection addObject:localCanvas];
}

- (void)setupVideoRemoteView:(LiveVideoRenderView *)view Uid:(NSInteger) uid{
    AgoraRtcVideoCanvas *remoteArea = [[AgoraRtcVideoCanvas alloc] init];
    remoteArea.uid = uid;
    view.uid = uid;
    view.videoCanvas = remoteArea;
    remoteArea.view = view.videoView;
    [self.agorEngine setupRemoteVideo:remoteArea];
}

- (void)enableVideo{
    [self.agorEngine enableVideo];
}

- (int)joinRoomByToken:(NSString *)token Room:(NSString *)roomId{
    return [self.agorEngine joinChannelByToken:token channelId:roomId info:nil uid:0 joinSuccess:^(NSString * channel, NSUInteger uid, NSInteger elapsed){
        NSLog(@"进入频道%@   用户:%ld",channel,uid);
    }];
}

- (void)leaveRoom{
    [self.agorEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        
    }];
}

//视频通话有远端用户进入（互相可见）
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    if(self.provideDelegate && self.role == AgoraClientRoleAudience){
        [self.provideDelegate didAddRemoteMember:uid];
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
