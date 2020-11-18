//
//  IMChannelManager.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "IMChannelManager.h"
#import "MedChannelMessage.h"

@interface IMChannelManager()<AgoraRtmChannelDelegate>

@end

@implementation IMChannelManager
{
    NSMutableDictionary <NSString*,AgoraRtmMember*>*memberDic;
    NSString *channelId;
}

- (instancetype)initWithId:(NSString *)channelId
{
    self = [super init];
    if (self) {
        self->channelId = channelId;
        self.imChannel = [[IMManager sharedManager] createChannelWithId:channelId ChannelDelegate:self];
        memberDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)rtmJoinChannel{
    [self.imChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
        if (errorCode == 0) {
            NSLog(@"加入频道");
        }
    }];
    
    [self.imChannel getMembersWithCompletion:^(NSArray<AgoraRtmMember *> *members, AgoraRtmGetMembersErrorCode errorCode) {
        [members enumerateObjectsUsingBlock:^(AgoraRtmMember *obj, NSUInteger idx, BOOL *stop) {
            [memberDic setObject:obj forKey:obj.userId];
        }];
    }];
}

- (void)leaveChannel{
    [self.imChannel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
        if (errorCode == 0) {
            NSLog(@"退出频道");
            [self destoryChannel];
        }
    }];
}

- (void)sendTextMessage:(NSString *)text{
    AgoraRtmMessage *msg = [[AgoraRtmMessage alloc] initWithText:text];
    [self.imChannel sendMessage:msg completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        
    }];
}

- (void)sendRawMessage:(NSData *)msgData Completion:(void(^)(void)) success{
    AgoraRtmSendMessageOptions *options = [[AgoraRtmSendMessageOptions alloc] init];
    options.enableHistoricalMessaging = YES;
    AgoraRtmRawMessage *msg = [[AgoraRtmRawMessage alloc] initWithRawData:msgData description:@""];
    [self.imChannel sendMessage:msg sendMessageOptions:options completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (errorCode == 0) {
            success();
        }
    }];
}

//发送图片消息
- (void)sendImageMessage:(UIImage *)img text:(NSString*) info{
    AgoraRtmImageMessage *msg = [[AgoraRtmImageMessage alloc] initWithText:info];
    
}
//销毁频道
- (void)destoryChannel{
    if([[IMManager sharedManager] destroyChannel:channelId]){
        NSLog(@"频道已释放");
    }
}

#pragma AgoraRtmChannelDelegate Imp

- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member{
    AgoraRtmRawMessage *rawMsg = (AgoraRtmRawMessage *)message;
    NSData *rawData = rawMsg.rawData;
    MedChannelMessage *msg = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
    
    NSLog(@"频道%@ 收到来自%@ 的消息:%@",member.channelId,member.userId,msg.context);
}

- (void)channel:(AgoraRtmChannel *)channel imageMessageReceived:(AgoraRtmImageMessage *)message fromMember:(AgoraRtmMember *)member{
    NSLog(@"频道收到了图片消息");
}

- (void)channel:(AgoraRtmChannel *)channel fileMessageReceived:(AgoraRtmFileMessage *)message fromMember:(AgoraRtmMember *)member{
    NSLog(@"频道收到了文件消息");
}

- (void)channel:(AgoraRtmChannel *)channel memberJoined:(AgoraRtmMember *)member{
    NSLog(@"有成员加入频道");
    [memberDic setObject:member forKey:member.userId];
}

- (void)channel:(AgoraRtmChannel *)channel memberLeft:(AgoraRtmMember *)member{
    NSLog(@"有成员离开频道");
    [memberDic removeObjectForKey:member.userId];
}

- (void)channel:(AgoraRtmChannel *)channel memberCount:(int)count{
    NSLog(@"频道成员数量%d",count);
}

- (void)dealloc{
    NSLog(@"IMChannel dealloc");
}

@end
