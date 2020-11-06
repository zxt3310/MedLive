//
//  SKLMeetView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/2.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SKLMeetViewDelegate <NSObject>

@optional

- (void)meetViewActCreateConsultation;
- (void)meetViewActCreateMeet;
- (void)meetViewActCreateLive;
- (void)meetViewActJoin;

@end

@interface SKLMeetView : UIView
@property (weak) id<SKLMeetViewDelegate> meetViewDelegate;
@end

NS_ASSUME_NONNULL_END
