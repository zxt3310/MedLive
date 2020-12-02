//
//  AppCommondCenter.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/5.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MedLiveUserModel.h"
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const RTCEngineDidReceiveMessage;
UIKIT_EXTERN NSString *const MedLoginCall;
UIKIT_EXTERN NSString *const MedRtmRejoinCall;

@protocol ThirdPlatDelegate <NSObject>
@optional

- (void)appDidEvocatedToLiveWithUrl:(NSURL *)url;
@end

@interface AppCommondCenter : NSObject

@property BOOL hasLogin;

@property MedLiveUserModel *currentUser;

@property (weak) id<ThirdPlatDelegate> evocateDelegate;
+ (instancetype)sharedCenter;

- (void)loginWithMobile:(NSString *)mobile Uid:(NSString *)uid Name:(NSString * _Nullable)username;
@end

NS_ASSUME_NONNULL_END
