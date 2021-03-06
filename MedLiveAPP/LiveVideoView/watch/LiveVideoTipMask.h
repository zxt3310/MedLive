//
//  LiveVideoTipMask.h
//  MedLiveAPP
//
//  Created by zxt on 2021/1/7.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveVideoTipMask : UIView
@property (nonatomic,strong,readonly) UIButton *backPlayBtn;
- (void)countWithStartTime:(NSString *)start State:(MedLiveRoomState)state;
@end

NS_ASSUME_NONNULL_END
