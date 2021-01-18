//
//  LiveRenderMaskView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/19.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RenderMaseDelegate <NSObject>

@optional
// start and pause
- (void)RenderMaskDidSwitchPlayStateComplate:(void(^)(MedLiveState))block;
// full screen
- (void)RenderMaskDidSwitchScreenStateComplate;
// Back button click callback if in full_screen state switch normal or Pop back
- (void)RenderMasekDidTapBack:(void(^)(MedLiveScreenState))block;
//开关摄像头
- (void)switchCamara:(void(^)(BOOL enable,BOOL isFirst))res;
//开关麦克风
- (void)switchMic:(void(^)(BOOL enable))res;
@end

@interface LiveRenderMaskView : UIButton
@property (weak) id<RenderMaseDelegate> maskDelegate;
- (void)fillTitle:(NSString *)title;
- (void)enableSideBar:(BOOL) enable;
//强制开启设备（被动触发）
- (void)openDeviceOnForce;
@end

NS_ASSUME_NONNULL_END
