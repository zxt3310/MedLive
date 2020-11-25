//
//  MedLiveInteractView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedLiveChatTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol interactViewDelegate <NSObject>
@optional

- (void)interactViewDidSendmessage:(NSString *)text Complete:(void(^)(MedChannelMessage* msg))result;
- (void)interactViewDidShareWithUrl:(void(^)(void))result;
@end

@interface MedLiveInteractView : UIView
- (instancetype)initWithViewDelegate:(id<interactViewDelegate>)delegate;
- (void)resetScroll;
@end

NS_ASSUME_NONNULL_END
