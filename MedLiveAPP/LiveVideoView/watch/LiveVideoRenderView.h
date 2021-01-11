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

-(id)initWithMaskDelegate:(id <RenderMaseDelegate>)delegate;
- (void)fillTitle:(NSString *)title;
- (void)showPlaceView:(BOOL)show Start:(nullable NSString *)startTime State:(MedLiveRoomState)state coverPic:(nullable NSString *)img;
- (void)addRemoteStream:(NSInteger)uid result:(void(^)(__kindof LiveView*))res;
- (void)removeRemoteStream:(NSInteger)uid;
- (void)enableSideBar:(BOOL) enable;
@end

NS_ASSUME_NONNULL_END
