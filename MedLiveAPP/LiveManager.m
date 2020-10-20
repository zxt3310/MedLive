//
//  LiveManager.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/10.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveManager.h"
#import "Utilies/AgoraCenter.h"
#import "LiveVideoRenderView.h"

@interface LiveManager()<AgoraRtcEngineDelegate>
@property (readonly)AgoraRtcEngineKit *agorEngine;
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

- (void)setupVideoLocalView:(AgoraRtcVideoCanvas *) local{
    [self.agorEngine setupLocalVideo:local];
    [areaCollection addObject:local];
}

- (void)enableVideo{
    [self.agorEngine enableVideo];
    //[self.agorEngine setParameters:@"{\"che.audio.live_for_comm\":true}"];
    //[self.agorEngine enableDualStreamMode:YES];
    //NSLog(@"加载本地视图 %d",res);
}

- (void)joinRoomByToken:(NSString *)token Room:(NSString *)roomId{
    [self.agorEngine joinChannelByToken:token channelId:roomId info:nil uid:0 joinSuccess:^(NSString * channel, NSUInteger uid, NSInteger elapsed){
        NSLog(@"进入频道%@   用户:%ld",channel,uid);
    }];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    AgoraRtcVideoCanvas *remoteArea = [[AgoraRtcVideoCanvas alloc] init];
    remoteArea.uid = uid;
    LiveVideoRenderView *remoteView = [[LiveVideoRenderView alloc] init];
    remoteView.uid = uid;
    remoteView.videoCanvas = remoteArea;
    remoteArea.view = remoteView;
    if(self.provideDelegate){
        [self.provideDelegate didAddRemoteMember:remoteView];
    }
    [areaCollection addObject:remoteArea];
    [self.agorEngine setupRemoteVideo:remoteArea];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteStateReason)reason elapsed:(NSInteger)elapsed{
    if(state == AgoraVideoRemoteStateStopped){
        for(AgoraRtcVideoCanvas *area in areaCollection){
            if(uid == area.uid){
                [areaCollection removeObject:area];
                break;
            }
        }
        
        if(self.provideDelegate){
            [self.provideDelegate didRemoteLeave:uid];
        }
    }
}

- (void)switchArea{
    
}


- (void)dealloc{
    [AgoraRtcEngineKit destroy];
}

@end
