//
//  MedLiveViewModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveViewModel.h"
#import "MedCreateLiveRequest.h"
#import "MedChannelTokenRequest.h"
#import "MedChannelStateRequest.h"
#import "LiveManager.h"
#import "MedLiveRoomInfoRequest.h"
#import "IMChannelManager.h"

@interface MedLiveViewModel()<IMChannelDelegate>

@end

@implementation MedLiveViewModel
{
    LiveManager *liveManager;
    IMChannelManager *channelManager;
    NSString *roomId;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        liveManager = [[LiveManager alloc] init];
        [liveManager setRole:AgoraClientRoleBroadcaster];
    }
    return self;
}

- (void)joinRtmChannelWithId:(NSString *)channelId{
    if (!channelManager) {
        channelManager = [[IMChannelManager alloc] initWithId:channelId];
        channelManager.channelDelegate = self;
        [channelManager rtmJoinChannel];
    }
}

- (void)setupLocalView:(__kindof UIView *)view{
    [liveManager setupVideoLocalView:view];
    [liveManager enableVideo];
}

- (void)joinChannel:(NSString *)channelName Token:(NSString *)token{
    WeakSelf
    [liveManager joinRoomByToken:token
                            Room:channelName
                            Uid:[AppCommondCenter sharedCenter].currentUser.uid
                        success:^{
        //发送开播信号
        [weakSelf sendLiveState:MedLiveRoomStateStart
                        UserId:[AppCommondCenter sharedCenter].currentUser.uid];
    }];
}

- (void)fetchRoomInfo:(NSString *)roomId Complete:(void(^)(MedLiveRoomBoardcast* ))res{
    MedLiveRoomInfoRequest *request = [[MedLiveRoomInfoRequest alloc] initWithRoomId:roomId];
    [request fetchWithComplete:^(__kindof MedLiveRoom *room) {
        MedLiveRoomBoardcast *bordcastRoom = (MedLiveRoomBoardcast *)room;
        self->roomId = room.roomId;
        res(bordcastRoom);
    }];
   
}

- (void)createRoomWithTitle:(NSString *)title ChannelId:(NSString *)channelId Complate:(void(^)(NSString *chanlToken))complateBlock{
    MedChannelTokenRequest *tokReq = [[MedChannelTokenRequest alloc] initWithRoomId:channelId
                                                                            Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    [tokReq startWithSucBlock:^(NSString * _Nonnull token) {
        NSLog(@"认证房间");
        complateBlock(token);
    }];
}

- (void)sendLiveState:(MedLiveRoomState)state UserId:(NSString *)uid{
    MedChannelStateRequest *request= [[MedChannelStateRequest alloc] initWithState:state RoomId:self->roomId Uid:uid];
    [request requestRoomState:^{
        if (state == MedLiveRoomStateStart) {
            [MedLiveAppUtilies showErrorTip:@"已开播"];
        }else{
            [MedLiveAppUtilies showErrorTip:@"已下播"];
        }
    }];
}

- (void)stopLive{
    [channelManager leaveChannel];
    [liveManager leaveRoom];
}

- (void)channelDidReceiveMessage:(MedChannelChatMessage *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:RTMEngineDidReceiveMessage object:message];
}

- (void)channelDidReceiveSignal:(nonnull MedChannelSignalMessage *)signal {
    
}


- (void)dealloc{
    NSLog(@"");
}
@end
