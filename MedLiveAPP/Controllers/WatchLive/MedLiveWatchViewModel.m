//
//  MedLiveWatchViewModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/20.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveWatchViewModel.h"
#import "IMChannelManager.h"
#import "MedChannelMessage.h"
#import "MedLiveRoomInfoRequest.h"
#import "MedLiveRoomBoardcast.h"
@interface MedLiveWatchViewModel()<IMChannelDelegate>
@end

@implementation MedLiveWatchViewModel
{
    IMChannelManager *manager;
    NSString *roomId;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejoinRtmJoinChannel) name:MedRtmRejoinCall object:nil];
        manager = [[IMChannelManager alloc] initWithId:@"zxt"];
        manager.channelDelegate = self;
        [manager rtmJoinChannel];
    }
    return self;
}

- (void)fetchRoomInfo:(NSString *)roomId Complete:(void(^)(MedLiveRoomBoardcast* ))res{
    MedLiveRoomInfoRequest *request = [[MedLiveRoomInfoRequest alloc] initWithRoomId:roomId];
    [request fetchWithComplete:^(MedLiveRoomBoardcast *room) {
        self->roomId = room.roomId;
        res(room);
    }];
}

- (void)rejoinRtmJoinChannel{
    [manager rejoinChannel];
}

- (void)sendMsg:(NSString *)text result:(void(^)(MedChannelMessage * msg)) result{
    AppCommondCenter *center = [AppCommondCenter sharedCenter];
    if (!center.hasLogin && self.pushCall) {
        self.pushCall(MedLoginCall);
        return;;
    }
    MedLiveUserModel *user = center.currentUser;
    NSString *name = user.userName?:user.uid;
    NSString *headerUrl = @"";
    MedChannelMessage *msg = [[MedChannelMessage alloc] initWith:name Pic:headerUrl Context:text];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:msg];
    [manager sendRawMessage:data Completion:^{
        NSLog(@"消息发送成功");
        result(msg);
    }];
}

- (void)leaveRtmChannel{
    [manager leaveChannel];
}

#pragma interactViewDelegate IMP
- (void)interactViewDidSendmessage:(NSString *)text Complete:(void (^)(MedChannelMessage* msg))result{
    [self sendMsg:text result:result];
}

- (void)interactViewDidShareWithUrl:(void(^)(void))result{
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@/join/room/boardcast/%@",Domain,roomId];
    result();
}

#pragma IMChannelDelegate IMP

- (void)channelDidReceiveMessage:(MedChannelMessage *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:RTCEngineDidReceiveMessage object:message];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
