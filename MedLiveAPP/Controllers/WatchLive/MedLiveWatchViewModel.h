//
//  MedLiveWatchViewModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/20.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MedLiveInteractView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^conctollerPresentCall)(NSString* callIndentifer);

@protocol SignalDelegate <NSObject>
@required
- (void)RTMDidReceiveVideoGrantRes:(void(^)(BOOL succesed))success;
- (void)RTMDidReceiveVideoDeniedRes:(void(^)(BOOL succesed))success;
- (void)RTMDidReceivePointMain:(NSInteger) targetId res:(void(^)(BOOL succesed))success;
@end

@class MedLiveRoomBoardcast;
@interface MedLiveWatchViewModel : NSObject <interactViewDelegate>
@property (nonatomic,weak) id<SignalDelegate> signalDelegate;
@property conctollerPresentCall pushCall;
- (void)fetchRoomInfo:(NSString *)roomId Complete:(void(^)(MedLiveRoomBoardcast* ))res;
- (void)leaveRtmChannel;
- (void)changeRoleState:(MedLiveRoleState)state;
- (void)getAttrbuite;
@end

@interface MedLiveSignelQueueModel :NSObject
@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,strong) id value;
@property (nonatomic,readonly) NSInteger validate;
- (void)validateGrow;
@end
NS_ASSUME_NONNULL_END
