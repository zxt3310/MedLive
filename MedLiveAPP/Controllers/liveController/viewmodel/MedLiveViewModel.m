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

@implementation MedLiveViewModel
{
    LiveManager *liveManager;
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

- (void)setupLocalView:(__kindof UIView *)view{
    [liveManager setupVideoLocalView:view];
    [liveManager enableVideo];
}

- (int)joinChannel:(NSString *)channelName Token:(NSString *)token{
    return [liveManager joinRoomByToken:token Room:channelName];
}

- (void)createRoomWithTitle:(NSString *)title ChannelId:(NSString *)channelId Complate:(void(^)(NSString *chanlToken))complateBlock{
    MedChannelTokenRequest *tokReq = [[MedChannelTokenRequest alloc] initWithRoomId:channelId Uid:@"0"];
    [tokReq startWithSucBlock:^(NSString * _Nonnull token) {
        NSLog(@"认证房间");
        complateBlock(token);
    }];
}

- (void)sendLiveState:(MedLiveRoomState)state RoomId:(NSString *)roomId UserId:(NSString *)uid{
    MedChannelStateRequest *request= [[MedChannelStateRequest alloc] initWithState:state RoomId:roomId Uid:uid];
    [request requestRoomState:^{
        if (state == MedLiveRoomStateStart) {
            NSLog(@"开播");
        }else{
            NSLog(@"下播");
        }
    }];
}

- (void)stopLive{
    [liveManager leaveRoom];
}

- (void)dealloc{
    NSLog(@"");
}
@end
