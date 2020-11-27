//
//  MutipleMeettingViewModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MutipleMeettingViewModel.h"
#import "LiveManager.h"
#import "MedChannelTokenRequest.h"
#import "MedLiveRoomInfoRequest.h"
#import "MedLiveRoomMeetting.h"
#import "MedLiveRoleStateRequest.h"
#import "MedChannelStateRequest.h"

@interface MutipleMeettingViewModel()<LiveManagerRemoteCanvasProvideDelegate>
@property LiveManager *manager;
@end

@implementation MutipleMeettingViewModel
{
    MedLiveRoomMeetting *roomMeet;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[LiveManager alloc] init];
        _manager.provideDelegate = self;
        [_manager settingEnvtype:MedLiveTypeMeetting];
        _manager.role = AgoraClientRoleBroadcaster;
        [_manager settingOpenVolumeIndication:YES];
    }
    return self;
}

- (void)fetchRoomInfoWithRoomId:(NSString *)roomId Complete:(void(^)(MedLiveRoomMeetting* ))res{
    if (!roomId) {
        NSLog(@"没有房间号");
        [MedLiveAppUtilies showErrorTip:@"无效的房间号"];
        return;
    }
    
    MedLiveRoomInfoRequest *request = [[MedLiveRoomInfoRequest alloc] initWithRoomId:roomId];
    [request fetchWithComplete:^(__kindof MedLiveRoom *room) {
        MedLiveRoomMeetting *meettingRoom = (MedLiveRoomMeetting *)room;
        self->roomMeet = meettingRoom;
        res(meettingRoom);
    }];
}

- (void)joinMeetting:(NSString *)channelId{
    NSString *uid =[AppCommondCenter sharedCenter].currentUser.uid;
    WeakSelf
    __weak MedLiveRoomMeetting *weakRoom = roomMeet;
    MedChannelTokenRequest *request = [[MedChannelTokenRequest alloc] initWithRoomId:channelId Uid:uid];
    [request startWithSucBlock:^(NSString * _Nonnull token) {
        [self.manager joinRoomByToken:token
                                Room:channelId
                                  Uid:uid success:^{
            if (weakRoom.owner == uid) {
                [weakSelf changeMeetState:MedLiveRoomStateStart];
            }else{
                [weakSelf changeRoleState:MedLiveRoleStateJoin];
            }
        }];
    }];
}


- (void)setupLocalView:(__kindof UIView *)localView{
    [self.manager setupVideoLocalView:localView];
    [self.manager enableVideo];
}

- (void)setupRemoteView:(__kindof UIView*)remoteView{
    [self.manager setupVideoRemoteView:remoteView];
}

- (void)muteLocalMic:(BOOL) mute{
    [self.manager muteLocalMic:mute];
}

- (void)disableLocalvideo:(BOOL)disable success:(void(^)(void))success{
    int res = [self.manager disableLocalCamera:disable];
    if (res == 0) {
        success();
    }
}

- (void)switchCamera{
    [self.manager switchCamera];
}

- (void)stopLive{
    if ([AppCommondCenter sharedCenter].currentUser.uid == roomMeet.owner) {
        [self changeMeetState:MedLiveRoomStateEnd];
    }else{
        [self changeRoleState:MedliveRoleStateLeave];
    }
    
    [self.manager leaveRoom];
}

//通话状态请求

- (void)changeMeetState:(MedLiveRoomState)state{
    MedChannelStateRequest *request = [[MedChannelStateRequest alloc] initWithState:state
                                                                             RoomId:roomMeet.roomId
                                                                                Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    [request requestRoomState:^{
        if (state == MedLiveRoomStateStart) {
            [MedLiveAppUtilies showErrorTip:@"会议开始"];
        }else if(state == MedLiveRoomStateEnd){
            [MedLiveAppUtilies showErrorTip:@"会议结束"];
        }
    }];
}

- (void)changeRoleState:(MedLiveRoleState)state{
    MedLiveRoleStateRequest *request = [[MedLiveRoleStateRequest alloc] initWithState:state
                                                                               RoomId:roomMeet.roomId
                                                                                  Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    [request requestRoleState:^{
        if (state == MedLiveRoleStateJoin) {
            [MedLiveAppUtilies showErrorTip:@"加入会议"];
        }else if(state == MedliveRoleStateLeave){
            [MedLiveAppUtilies showErrorTip:@"离开会议"];
        }
    }];
}

#pragma viewModel delegate imp
- (void)didAddRemoteMember:(NSUInteger)uid{
    if (self.meettingDelegate) {
        [self.meettingDelegate meetingDidJoinMember:uid];
    }
}
- (void)didRemoteLeave:(NSInteger) uid{
    if (self.meettingDelegate) {
        [self.meettingDelegate meetingDidLeaveMember:uid];
    }
}

- (void)didReceiveRemoteAudio:(NSArray<AgoraRtcAudioVolumeInfo *> *)speakers{
    if (self.meettingDelegate) {
        [speakers enumerateObjectsUsingBlock:^(AgoraRtcAudioVolumeInfo * info, NSUInteger idx, BOOL * stop) {
            [self.meettingDelegate meettingMemberSpeaking:info.uid];
        }];
    }
}

- (void)remote:(NSInteger)uid DidDisabledCamera:(BOOL)disable{
    if (self.meettingDelegate) {
        [self.meettingDelegate meettingMember:uid DidCloseCamera:disable];
    }
}

- (void)remoteBecomeActiveSpeaker:(NSInteger)uid{
    if (self.meettingDelegate) {
        [self.meettingDelegate meetMemberBecomeActive:uid];
    }
}

- (void)dealloc
{
    
}
@end
