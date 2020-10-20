//
//  LiveVideoRenderView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcKit/AgoraObjects.h>
NS_ASSUME_NONNULL_BEGIN

@interface LiveVideoRenderView : UIView

@property (weak) AgoraRtcVideoCanvas *videoCanvas;

@property (strong,readonly) UIView *videoView;

@property NSInteger uid;

@end

NS_ASSUME_NONNULL_END
