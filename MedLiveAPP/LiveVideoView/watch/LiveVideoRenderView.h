//
//  LiveVideoRenderView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveVideoRenderView : LiveView
@property (nonatomic) CGFloat remoteWidgetBottom;

-(id)initWithMaskDelegate:(id <RenderMaseDelegate>)delegate;
- (void)fillTitle:(NSString *)title;
- (void)showPlaceView:(BOOL)show Start:(nullable NSString *)startTime State:(MedLiveRoomState)state coverPic:(nullable NSString *)img;
- (void)addRemoteStream:(NSInteger)uid result:(void(^)(__kindof LiveView*))res;
- (void)removeRemoteStream:(NSInteger)uid;
- (void)enableSideBar:(BOOL) enable;

//设置关闭摄像头的远端流 为默认画面 返回是否找到该流
- (BOOL)remote:(NSInteger)uid DidEnabledCamara:(BOOL)enabled;
@end

NS_ASSUME_NONNULL_END
