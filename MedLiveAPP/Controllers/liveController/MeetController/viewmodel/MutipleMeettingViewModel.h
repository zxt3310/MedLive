//
//  MutipleMeettingViewModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MedMutipleMeetingDelegate <NSObject>
@optional
- (void)meetingDidJoinMember:(NSInteger) uid;
- (void)meetingDidLeaveMember:(NSInteger) uid;
- (void)meettingMemberSpeaking:(NSInteger)uid;
@end

@interface MutipleMeettingViewModel : NSObject
@property (weak) id<MedMutipleMeetingDelegate> meettingDelegate;
- (void)setupLocalView:(__kindof UIView *)localView;
- (void)setupRemoteView:(__kindof UIView*)remoteView;
- (void)joinMeetting:(NSString *)channelId;
- (void)stopLive;
- (void)muteLocalMic:(BOOL) mute;
- (void)disableLocalvideo:(BOOL)disable success:(void(^)(void))success;
- (void)switchCamera;
@end

NS_ASSUME_NONNULL_END
