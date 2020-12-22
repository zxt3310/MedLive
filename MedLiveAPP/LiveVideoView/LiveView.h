//
//  LiveView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcKit/AgoraObjects.h>
#import "LiveRenderMaskView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveView : UIView

@property (nonatomic)AgoraRtcVideoCanvas *videoCanvas;

@property (nonatomic,strong) UIView *videoView;

@property (nonatomic) NSInteger uid;

- (void)renewVideoView;

@end

NS_ASSUME_NONNULL_END
