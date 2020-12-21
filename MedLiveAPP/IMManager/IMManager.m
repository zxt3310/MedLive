//
//  IMManager.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "IMManager.h"
#import "AgoraCenter.h"
#import "MedRtmTokenRequest.h"

@interface IMManager()<AgoraRtmDelegate>
@property (readonly) AgoraRtmKit *rtmEngine;
@end

@implementation IMManager
{
    
}
static IMManager *manager = nil;
+ (id)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rtmEngine = [[AgoraRtmKit alloc] initWithAppId:[AgoraCenter appId] delegate:self];
    }
    return self;
}

- (void)loginToAgoraServiceWithId:(NSString *)userId{
    MedRtmTokenRequest *request = [[MedRtmTokenRequest alloc] initWithUid:userId];
    [request startWithSucBlock:^(NSString * _Nonnull token) {
        [self.rtmEngine loginByToken:token user:userId completion:^(AgoraRtmLoginErrorCode errorCode) {
            //登录结果
            if (errorCode == 0) {
                NSLog(@"成功登录聊天系统");
                [[NSNotificationCenter defaultCenter] postNotificationName:MedRtmRejoinCall object:nil];
                
                //设置RTM 自定义属性
                MedLiveUserModel *curUser = [AppCommondCenter sharedCenter].currentUser;
                NSString *userName = KIsBlankString(curUser.userName)?curUser.uid:curUser.userName;
                NSString *headerUrl = Kstr(curUser.headerImgUrl);
                [[IMManager sharedManager] setLocalUserAttrbuteWithName:userName Headerpic:headerUrl];
                
            }else if (errorCode == AgoraRtmLoginErrorAlreadyLogin){
                [self.rtmEngine logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
                    [self loginToAgoraServiceWithId:userId];
                }];
            }
        }];
    }];
}

- (void)setLocalUserAttrbuteWithName:(NSString *)name Headerpic:(NSString *)url{
    AgoraRtmAttribute *arttributeName = [[AgoraRtmAttribute alloc] init];
    arttributeName.key = @"username";
    arttributeName.value = name;
    
    AgoraRtmAttribute *attributeHeader = [[AgoraRtmAttribute alloc] init];
    attributeHeader.key = @"headerpic";
    attributeHeader.value = url;
    
    [self.rtmEngine setLocalUserAttributes:@[arttributeName,attributeHeader] completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
        if (!errorCode) {
            NSLog(@"全量用户attribute 提交成功");
        }else{
            NSLog(@"全量用户attribute 提交失败");
        }
    }];
}

- (AgoraRtmChannel*)createChannelWithId:(NSString *)channelId ChannelDelegate:(id<AgoraRtmChannelDelegate>)delegate{
    return [self.rtmEngine createChannelWithId:channelId delegate:delegate];
}

- (BOOL)destroyChannel:(NSString *)channelId{
    return [self.rtmEngine destroyChannelWithId:channelId];
}

- (void)getUserAttributeWithId:(NSString *)uid Suc:(void(^)(NSString *name,NSString *picUrl)) result{
    [self.rtmEngine getUserAllAttributes:uid completion:^(NSArray<AgoraRtmAttribute *> *attributes, NSString *userId, AgoraRtmProcessAttributeErrorCode errorCode) {
        if (errorCode == AgoraRtmAttributeOperationErrorOk) {
            NSString *userName;
            NSString *headerPic;
            for (AgoraRtmAttribute* atr in attributes) {
                if ([atr.key isEqualToString:@"username"]) {
                    userName = atr.value;
                }
                if ([atr.key isEqualToString:@"headerpic"]) {
                    headerPic = atr.value;
                }
            }
            result(userName,headerPic);
        }
    }];
}

#pragma AgoraRtmDelegate Imp

- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason{
    NSLog(@"RTM连接状态发生改变");
}

- (void)rtmKitTokenDidExpire:(AgoraRtmKit *)kit{
    NSLog(@"RTM Token已过期");
}

- (void)rtmKit:(AgoraRtmKit *)kit PeersOnlineStatusChanged:(NSArray<AgoraRtmPeerOnlineStatus *> *)onlineStatus{
    NSLog(@"友人 在线状态改变回调");
}

- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId{
    NSLog(@"收到消息：%@,来自:%@",message.text,peerId);
}

- (void)rtmKit:(AgoraRtmKit *)kit imageMessageReceived:(AgoraRtmImageMessage *)message fromPeer:(NSString *)peerId{
    NSLog(@"收到图片消息，来自：%@",peerId);
}






#pragma AgoraRtmChannelDelegate Imp
@end
