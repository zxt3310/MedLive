//
//  MedLiveLoginView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/26.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MedLiveLoginView;

@protocol LoginViewDelegate <NSObject>

@optional

- (void)loginView:(MedLiveLoginView *)view SendMobileMsg:(NSString *)mobile Complete:(void (^)(NSString *,BOOL))completeBlock;

- (void)loginView:(MedLiveLoginView *)view StartLoginWithMobile:(NSString *)mobile Code:(NSString *)code;
@end

@interface MedLiveLoginView : UIView
@property (weak) id<LoginViewDelegate>loginDelegate;

@end

NS_ASSUME_NONNULL_END
