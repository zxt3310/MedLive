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

- (void)rejoinChannel{
    [self leaveChannel];
    [memberDic removeAllObjects];
    self.imChannel = [[IMManager sharedManager] createChannelWithId:channelId ChannelDelegate:self];
    [self rtmJoinChannel];
}

- (void)sendTextMessage:(NSString *)text Success:(void(^)(void))result{
    AgoraRtmMessage *msg = [[AgoraRtmMessage alloc] initWithText:text];
    //记录历史消息
    AgoraRtmSendMessageOptions *options = [[AgoraRtmSendMessageOptions alloc] init];
    options.enableHistoricalMessaging = YES;
    [self.imChannel sendMessage:msg sendMessageOptions:options completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (errorCode == AgoraRtmSendChannelMessageErrorOk) {
            result();
        }
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

- (void)TotalMembersOfChannel:(void(^)(NSArray <NSString*>* members))result{
    [self.imChannel getMembersWithCompletion:^(NSArray<AgoraRtmMember *> * _Nullable members, AgoraRtmGetMembersErrorCode errorCode) {
        if (errorCode == AgoraRtmGetMembersErrorOk) {
            NSMutableArray <NSString *> *memberAry = [NSMutableArray array];
            for (AgoraRtmMember *member in members) {
                [memberAry addObject:member.userId];
            }
            result([memberAry copy]);
        }
    }];
}

- (void)getChannelAttributes{
    [[IMManager sharedManager] getChannelAllAttributes:channelId completion:^(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (AgoraRtmChannelAttribute *attr in attributes) {
            if ([attr.key isEqualToString:SKLMessageSignal_VideoGrant]) {
                NSString *attrStr = attr.value;
                NSDictionary *value = [MedLiveAppUtilies stringToJsonDic:attrStr];
                if (value) {
                    [dic setValue:value forKey:attr.key];
                }
            }
            else if([attr.key isEqualToString:SKLMessageSignal_Pointmain]){
                NSString *attrStr = attr.value;
                [dic setValue:attrStr forKey:attr.key];
            }
        }
        if(self.channelDelegate && [self.channelDelegate respondsToSelector:@selector(channelDidChangeAttribute:)]){
            [self.channelDelegate channelDidChangeAttribute:[dic copy]];
        }
    }];
}

//发送图片消息  预留
- (void)sendImageMessage:(UIImage *)img text:(NSString*) info{
    
    
}
//销毁频道
- (void)destoryChannel{
    if([[IMManager sharedManager] destroyChannel:channelId]){
        NSLog(@"频道已释放");
    }
}

#pragma AgoraRtmChannelDelegate Imp
//张梨琼 14
- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member{
    if (message.type == AgoraRtmMessageTypeText) {
        NSString *context = message.text;
        id jsonDic = [MedLiveAppUtilies stringToJsonDic:context];
        if (!jsonDic) {
            NSLog(@"收到id为%@ 的消息，解析失败",member.userId);
            return;
        }
        MedChannelMessage *msg = [MedChannelMessage yy_modelWithJSON:jsonDic];
        if (!msg) {
            NSLog(@"收到id为%@ 的消息，解析失败",member.userId);
            return;
        }
        
        [[IMManager sharedManager] getUserAttributeWithId:member.userId Suc:^(NSString *name, NSString *picUrl) {
            if (msg.type == MedChannelMessageTypeChat) {
                MedChannelChatMessage *chat = [MedChannelChatMessage yy_modelWithJSON:jsonDic];
                chat.peerName = name;
                chat.peerHeadPic = picUrl;
                chat.peerId = member.userId;
                
                if (self.channelDelegate && [self.channelDelegate respondsToSelector:@selector(channelDidReceiveMessage:)]) {
                    [self.channelDelegate channelDidReceiveMessage:chat];
                }
            }
            else if(msg.type == MedChannelMessageTypeSignal){
                MedChannelSignalMessage *signal = [MedChannelSignalMessage yy_modelWithJSON:jsonDic];
                signal.peerName = name;
                signal.peerHeadPic = picUrl;
                signal.peerId = member.userId;
                
                if (self.channelDelegate && [self.channelDelegate respondsToSelector:@selector(channelDidReceiveSignal:)]) {
                    [self.channelDelegate channelDidReceiveSignal:signal];
                }
            }
        }];
    }
}

- (void)channel:(AgoraRtmChannel *)channel imageMessageReceived:(AgoraRtmImageMessage *)message fromMember:(AgoraRtmMember *)member{
    NSLog(@"频道收到了图片消息");
}

- (void)channel:(AgoraRtmChannel *)channel fileMessageReceived:(AgoraRtmFileMessage *)message fromMember:(AgoraRtmMember *)member{
    NSLog(@"频道收到了文件消息");
}
//频道属性变更回调
- (void)channel:(AgoraRtmChannel *)channel attributeUpdate:(NSArray<AgoraRtmChannelAttribute *> *)attributes{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (AgoraRtmChannelAttribute *attr in attributes) {
        if ([attr.key isEqualToString:SKLMessageSignal_VideoGrant]) {
            NSString *attrStr = attr.value;
            NSDictionary *value = [MedLiveAppUtilies stringToJsonDic:attrStr];
            if (value) {
                [dic setValue:value forKey:attr.key];
            }
        }
        else if([attr.key isEqualToString:SKLMessageSignal_Pointmain]){
            NSString *attrStr = attr.value;
            [dic setValue:attrStr forKey:attr.key];
        }
    }
    if(self.channelDelegate && [self.channelDelegate respondsToSelector:@selector(channelDidChangeAttribute:)]){
        [self.channelDelegate channelDidChangeAttribute:[dic copy]];
    }
}

- (void)channel:(AgoraRtmChannel *)channel memberJoined:(AgoraRtmMember *)member{
    NSLog(@"有成员加入频道");
    [MedLiveAppUtilies showErrorTip:@"有成员加入频道"];
    [memberDic setObject:member forKey:member.userId];
}

- (void)channel:(AgoraRtmChannel *)channel memberLeft:(AgoraRtmMember *)member{
    NSLog(@"有成员离开频道");
    [MedLiveAppUtilies showErrorTip:@"有成员离开频道"];
    [memberDic removeObjectForKey:member.userId];
}

- (void)channel:(AgoraRtmChannel *)channel memberCount:(int)count{
    NSLog(@"频道成员数量%d",count);
}

- (void)dealloc{
    NSLog(@"IMChannel dealloc");
}

@end
