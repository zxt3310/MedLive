//
//  SKLMeetJoinMeetController.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/25.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedLiveRoomMeetting;
@interface SKLMeetJoinMeetController : MedLiveBaseFlexViewController
@property NSString *roomId;
@property (nonatomic) MedLiveRoomMeetting *room;
@end
