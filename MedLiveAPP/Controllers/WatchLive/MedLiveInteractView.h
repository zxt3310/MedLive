//
//  MedLiveInteractView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedLiveChatTableCell.h"
#import "MedLiveRoomBoardcast.h"

NS_ASSUME_NONNULL_BEGIN

@protocol interactViewDelegate <NSObject>
@optional

- (void)interactViewDidSendmessage:(NSString *)text Complete:(void(^)(MedChannelMessage* msg))result;
- (void)interactViewDidShareWithUrl:(void(^)(void))result;
- (void)interactViewNeedSetupIntroduce:(void(^)(NSString *title,NSString* startTime, NSString * introStr, NSArray<NSString *> *pics))callBack;
@end

@interface MedLiveInteractView : UIView

- (instancetype)initWithViewDelegate:(id<interactViewDelegate>)delegate;
- (void)setupIntorduceScroll;//加载介绍
- (void)resetScroll;
@end

NS_ASSUME_NONNULL_END
