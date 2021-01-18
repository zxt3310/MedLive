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
#import "MedLiveAddFavorite.h"
#import <YYModel.h>
#import <LGAlertView.h>

@interface MedLiveWatchViewModel()<IMChannelDelegate>
@end

@implementation MedLiveWatchViewModel
{
    IMChannelManager *manager;
    MedLiveRoomBoardcast *boardRoom;
    BOOL isMediaOn;
    dispatch_source_t timer;
    NSMutableArray <MedLiveSignelQueueModel *> *signalQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isMediaOn = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rejoinRtmJoinChannel)
                                                     name:MedRtmRejoinCall
                                                   object:nil];
        signalQueue = [NSMutableArray array];
        [self createSingalQueue];
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

//拉取频道attribute
- (void)getAttrbuite{
    [manager getChannelAttributes];
}

- (void)sendMsg:(NSString *)text result:(void(^)(MedChannelChatMessage * msg)) result{
    AppCommondCenter *center = [AppCommondCenter sharedCenter];
    if (!center.hasLogin && self.pushCall) {
        self.pushCall(MedLoginCall);
        return;
    }
    
    MedLiveUserModel *me = center.currentUser;
    MedChannelChatMessage *msg = [[MedChannelChatMessage alloc] initWithText:text];
    msg.peerId = me.uid;
    msg.peerHeadPic = [NSString stringWithFormat:@"%@%@",Cdn_domain,me.headerImgUrl];
    msg.peerName = me.userName;
    NSString *msgJson = [msg yy_modelToJSONString];
    [manager sendTextMessage:msgJson Success:^{
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

#pragma mark interactViewDelegate IMP
- (void)interactViewDidSendmessage:(NSString *)text Complete:(void (^)(MedChannelChatMessage* msg))result{
    [self sendMsg:text result:result];
}

- (void)interactViewDidShareWithUrl:(void(^)(void))result{
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@/join/room/boardcast/%@",Domain,boardRoom.roomId];
    result();
}

- (void)interactViewNeedSetupIntroduce:(void(^)(NSString *title,NSString* startTime, NSString * introStr,BOOL isFavor, NSArray<NSString *> *pics))callBack{
    NSString *json = boardRoom.introPicsJosn;
    if (json) {
        NSArray *jsonObj = (NSArray *)[MedLiveAppUtilies stringToJsonDic:json];
        if (jsonObj) {
            callBack(boardRoom.roomTitle,boardRoom.startTime,boardRoom.desc,boardRoom.favor==0?NO:YES,jsonObj);
        }
    }
}

- (void)interactViewDidStoreLove:(BOOL)favor result:(void(^)(void))res{
    if (favor) {
        MedLiveAddFavorite *requset = [[MedLiveAddFavorite alloc] initWithUid:[AppCommondCenter sharedCenter].currentUser.uid RoomId:boardRoom.roomId];
        [requset addFavorWithSuccess:res];
    }else{
        MedLiveRemoveFavorite *request = [[MedLiveRemoveFavorite alloc] initWithUid:[AppCommondCenter sharedCenter].currentUser.uid RoomId:boardRoom.roomId];
        [request removeFavorWithSuccess:res];
    }
    
}

- (void)createSingalQueue{
    dispatch_queue_t signal_queue = dispatch_queue_create("com.saikanglive.app", DISPATCH_QUEUE_CONCURRENT);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, signal_queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC, 0);
    __weak NSMutableArray *queueAry = signalQueue;
    WeakSelf
    dispatch_source_set_event_handler(timer, ^{
        @synchronized (queueAry) {
            if (queueAry.count) {
                MedLiveSignelQueueModel *model = [queueAry firstObject];
                if (model.validate >2) {
                    [queueAry removeObject:model];
                    NSLog(@"指令失效，从队列中移除");
                }else{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [weakSelf commitSignal:model res:^(BOOL success) {
                            if (success) {
                                [queueAry removeObject:model];
                                NSLog(@"指令生效");
                            }else{
                                [model validateGrow];
                                NSLog(@"指令未处理，保存队列");
                            }
                        }];
                    });

                }
            }
        }
    });
    dispatch_resume(timer);
}

- (void)commitSignal:(MedLiveSignelQueueModel *)model res:(void(^)(BOOL success))succesed{
    if ([model.notificationName isEqualToString:SKLMessageSignal_VideoGrant]) {
        [self.signalDelegate RTMDidReceiveVideoGrantRes:succesed];
    }else if ([model.notificationName isEqualToString:SKLMessageSignal_VideoDenied]){
        [self.signalDelegate RTMDidReceiveVideoDeniedRes:succesed];
    }else if([model.notificationName isEqualToString:SKLMessageSignal_Pointmain]){
        [self.signalDelegate RTMDidReceivePointMain:[model.value integerValue] res:succesed];
    }
}

#pragma IMChannelDelegate IMP

- (void)channelDidReceiveMessage:(MedChannelChatMessage *)message{
    [[NSNotificationCenter defaultCenter] postNotificationName:RTMEngineDidReceiveMessage object:message];
}

- (void)channelDidReceiveSignal:(MedChannelSignalMessage *)signal{
    [[NSNotificationCenter defaultCenter] postNotificationName:RTMEngineDidReceiveSignal object:signal];
}

- (void)channelDidChangeAttribute:(NSDictionary *)attribute{
    NSDictionary *authorMap = [attribute objectForKey:SKLMessageSignal_VideoGrant];
    id videoSignal = [authorMap valueForKey:[AppCommondCenter sharedCenter].currentUser.uid];
    if (videoSignal) {
        if ([videoSignal boolValue] != isMediaOn) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:
//                                                                !isMediaOn?
//                                                                      SKLMessageSignal_VideoGrant
//                                                                      :SKLMessageSignal_VideoDenied
//                                                                object:nil];
            MedLiveSignelQueueModel *model = [[MedLiveSignelQueueModel alloc] init];
            model.notificationName = !isMediaOn ? SKLMessageSignal_VideoGrant : SKLMessageSignal_VideoDenied;
            [signalQueue addObject:model];
            isMediaOn = !isMediaOn;
        }
    }
    
    NSString *target = [attribute objectForKey:SKLMessageSignal_Pointmain];
    if (target) {
        MedLiveSignelQueueModel *model = [[MedLiveSignelQueueModel alloc] init];
        model.notificationName = SKLMessageSignal_Pointmain;
        model.value = target;
        [signalQueue addObject:model];
        //[[NSNotificationCenter defaultCenter] postNotificationName:SKLMessageSignal_Pointmain object:target];
    }
}

- (void)dealloc
{
    dispatch_source_cancel(timer);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@implementation MedLiveSignelQueueModel

- (void)validateGrow{
    _validate++;
}

@end
