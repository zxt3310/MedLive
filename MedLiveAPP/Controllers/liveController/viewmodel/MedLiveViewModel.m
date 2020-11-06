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

- (void)createRoomWithTitle:(NSString *)title Description:(NSString *)desc Complate:(void(^)(NSString* chanlId, NSString *chanlToken, NSString *roomID))complateBlock{
    MedCreateLiveRequest *req = [[MedCreateLiveRequest alloc] initWithTitle:title Desc:desc Uid:@"" Start:@"" picUrl:@""];
    [req startWithSucBlock:^(NSString * _Nonnull channelId, NSString * _Nonnull title, NSString * _Nonnull roomId) {
        NSLog(@"创建频道 %@, 标题: %@, 本地id:%@",channelId,title,roomId);
        MedChannelTokenRequest *tokReq = [[MedChannelTokenRequest alloc] initWithRoomId:channelId Uid:@"0"];
        [tokReq startWithSucBlock:^(NSString * _Nonnull token) {
            NSLog(@"认证房间");
            complateBlock(channelId,token,roomId);
        }];
    }];
}

- (void)stopLive{
    [liveManager leaveRoom];
}

- (void)dealloc{
    NSLog(@"");
}
@end
