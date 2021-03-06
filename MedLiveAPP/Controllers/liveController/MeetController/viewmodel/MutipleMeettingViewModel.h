//
//  MutipleMeettingViewModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PatientInfoPushNotification @"show_patient"
#define MemberDidChangeNotification @"member_diffent"

NS_ASSUME_NONNULL_BEGIN
@class MedLiveRoomMeetting;
@protocol MedMutipleMeetingDelegate <NSObject>
@optional
- (void)meetingDidJoinMember:(NSInteger) uid;
- (void)meetingDidLeaveMember:(NSInteger) uid;
- (void)meettingMemberSpeaking:(NSInteger)uid;
- (void)meettingMember:(NSInteger)uid DidCloseCamera:(BOOL) closed;
- (void)meetMemberBecomeActive:(NSInteger)uid;
@end

@interface MutipleMeettingViewModel : NSObject <UITableViewDelegate,UITableViewDataSource>
@property (weak) id<MedMutipleMeetingDelegate> meettingDelegate;
- (void)fetchRoomInfoWithRoomId:(NSString *)roomId Complete:(void(^)(MedLiveRoomMeetting* ))res;
- (void)setupLocalView:(__kindof UIView *)localView;
- (void)setupRemoteView:(__kindof UIView*)remoteView;
- (void)joinMeetting:(NSString *)channelId;
- (void)stopLive;
- (void)muteLocalMic:(BOOL) mute;
- (void)disableLocalvideo:(BOOL)disable success:(void(^)(void))success;
- (void)switchCamera;
- (NSArray *)getDocs;
@end

NS_ASSUME_NONNULL_END
