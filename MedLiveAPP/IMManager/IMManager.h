//
//  IMManager.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtmKit/AgoraRtmKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface IMManager : NSObject
@property (nonatomic,readonly) NSString *rtmToken;
+ (instancetype)sharedManager;
//登录声网服务器
- (void)loginToAgoraServiceWithId:(NSString *)userId;
- (AgoraRtmChannel*)createChannelWithId:(NSString *)channelId ChannelDelegate:(id<AgoraRtmChannelDelegate>)delegate;
- (BOOL)destroyChannel:(NSString *)channelId;
- (void)setLocalUserAttrbuteWithName:(NSString *)name Headerpic:(NSString *)url;
- (void)getUserAttributeWithId:(NSString *)uid Suc:(void(^)(NSString *name,NSString *picUrl)) result;
- (void)getChannelAllAttributes:(NSString *)channelId completion:(void(^)(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode))block;
@end

NS_ASSUME_NONNULL_END
