//
//  LiveManager.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/10.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "Utilies/AgoraCenter.h"
#import "LiveVideoRenderView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol LiveManagerRemoteCanvasProvideDelegate <NSObject>
@optional
- (void)didAddRemoteMember:(NSUInteger)uid;
- (void)didRemoteLeave:(NSInteger) uid;
@end

@interface LiveManager : NSObject
@property (nonatomic) AgoraClientRole role;
@property (weak) id<LiveManagerRemoteCanvasProvideDelegate> provideDelegate;
- (void)settingEnvtype:(MedLiveType) type;
- (void)enableVideo;
- (void)setupVideoLocalView:(__kindof LiveView *) view;
- (int)joinRoomByToken:(NSString *)token Room:(NSString *)roomId Uid:(NSString *)uid;
- (void)setupVideoRemoteView:(UIView *)view;
- (MedLiveState)pauseOrPlay:(MedLiveState)stateBefore;
- (void)leaveRoom;
@end

NS_ASSUME_NONNULL_END
