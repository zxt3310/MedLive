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
#import "MedLiveRoleStateRequest.h"
#import <YYModel.h>
@interface MedLiveWatchViewModel()<IMChannelDelegate>
@end

@implementation MedLiveWatchViewModel
{
    IMChannelManager *manager;
    MedLiveRoomBoardcast *boardRoom;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rejoinRtmJoinChannel)
                                                     name:MedRtmRejoinCall
                                                   object:nil];
    }
    return self;
}

- (void)joinRtmChannelWithId:(NSString *)channelId{
    if (!manager) {
        manager = [[IMChannelManager alloc] initWithId:channelId];
        manager.channelDelegate = self;
        [manager rtmJoinChannel];
    }
}

- (void)fetchRoomInfo:(NSString *)roomId Complete:(void(^)(MedLiveRoomBoardcast* ))res{
    MedLiveRoomInfoRequest *request = [[MedLiveRoomInfoRequest alloc] initWithRoomId:roomId];
    [request fetchWithComplete:^(MedLiveRoomBoardcast *room) {
        self->boardRoom = room;
        [self joinRtmChannelWithId:room.channelId];
        res(room);
    }];
}

- (void)rejoinRtmJoinChannel{
    [manager rejoinChannel];
}

- (void)sendMsg:(NSString *)text result:(void(^)(MedChannelChatMessage * msg)) result{
    AppCommondCenter *center = [AppCommondCenter sharedCenter];
    if (!center.hasLogin && self.pushCall) {
        self.pushCall(MedLoginCall);
        return;
    }
    MedLiveUserModel *user = center.currentUser;
    NSString *name = user.userName?:user.uid;
    NSString *headerUrl = @"";
    MedChannelChatMessage *msg = [[MedChannelChatMessage alloc] initWithUid:center.currentUser.uid
                                                                   Name:name
                                                                    Pic:headerUrl
                                                                Context:text];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:msg];
    [manager sendRawMessage:data Completion:^{
        NSLog(@"消息发送成功");
        result(msg);
    }];
}

- (void)leaveRtmChannel{
    [manager leaveChannel];
}

- (void)changeRoleState:(MedLiveRoleState)state{
    MedLiveRoleStateRequest *request = [[MedLiveRoleStateRequest alloc] initWithState:state
                                                                               RoomId:boardRoom.roomId
                                                                                  Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    [request requestRoleState:^{
        if (state == MedLiveRoleStateJoin) {
            [MedLiveAppUtilies showErrorTip:@"加入直播"];
        }else if(state == MedliveRoleStateLeave){
            [MedLiveAppUtilies showErrorTip:@"离开直播"];
        }
    }];
}

#pragma interactViewDelegate IMP
- (void)interactViewDidSendmessage:(NSString *)text Complete:(void (^)(MedChannelChatMessage* msg))result{
    [self sendMsg:text result:result];
}

- (void)interactViewDidShareWithUrl:(void(^)(void))result{
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@/join/room/boardcast/%@",Domain,boardRoom.roomId];
    result();
}

- (void)interactViewNeedSetupIntroduce:(void(^)(NSString *title,NSString* startTime, NSString * introStr, NSArray<NSString *> *pics))callBack{
    NSString *json = boardRoom.introPicsJosn;
    if (json) {
        NSArray *jsonObj = (NSArray *)[MedLiveAppUtilies stringToJsonDic:json];
        if (jsonObj) {
            callBack(boardRoom.roomTitle,boardRoom.startTime,boardRoom.desc,jsonObj);
        }
    }
}

- (void)interactViewDidStoreLove:(BOOL)cancel{
    if (!cancel) {
        MedChannelSignalMessage *signal = [[MedChannelSignalMessage alloc] initWithMessageSignal:MedMessageSignalTypeStreamAllow
                                                                                    Target:[AppCommondCenter sharedCenter].currentUser.uid];
        [[NSNotificationCenter defaultCenter] postNotificationName:RTMEngineDidReceiveSignal object:signal];
    }
}

#pragma IMChannelDelegate IMP

- (void)channelDidReceiveMessage:(MedChannelChatMessage *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:RTCEngineDidReceiveMessage object:message];
}

- (void)channelDidReceiveSignal:(MedChannelSignalMessage *)signal{
    [[NSNotificationCenter defaultCenter] postNotificationName:RTMEngineDidReceiveSignal object:signal];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
