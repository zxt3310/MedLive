//
//  LiveManager.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/10.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol LiveManagerRemoteCanvasProvideDelegate <NSObject>
@optional
- (void)didAddRemoteMember:(UIView *)view;
- (void)didRemoteLeave:(NSInteger) uid;
@end

@interface LiveManager : NSObject
@property (nonatomic) AgoraClientRole role;
@property (weak) id<LiveManagerRemoteCanvasProvideDelegate> provideDelegate;

- (void)enableVideo;
- (void)setupVideoLocalView:(AgoraRtcVideoCanvas *) local;
- (void)joinRoomByToken:(NSString *)token Room:(NSString *)roomId;
- (void)switchArea;
@end

NS_ASSUME_NONNULL_END
