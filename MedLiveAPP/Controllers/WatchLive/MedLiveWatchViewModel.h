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

@class MedLiveRoomBoardcast;
@interface MedLiveWatchViewModel : NSObject <interactViewDelegate>
@property conctollerPresentCall pushCall;
- (void)fetchRoomInfo:(NSString *)roomId Complete:(void(^)(MedLiveRoomBoardcast* ))res;
- (void)leaveRtmChannel;
- (void)changeRoleState:(MedLiveRoleState)state;
@end

NS_ASSUME_NONNULL_END
