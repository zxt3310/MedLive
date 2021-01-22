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

UIKIT_EXTERN NSString *const RTMEngineDidReceiveMessage;
UIKIT_EXTERN NSString *const RTMEngineDidReceiveSignal;
UIKIT_EXTERN NSString *const MedLoginCall;
UIKIT_EXTERN NSString *const MedRtmRejoinCall;
UIKIT_EXTERN NSString *const MedLiveHistoryBackPlay;

@protocol ThirdPlatDelegate <NSObject>
@optional

- (void)appDidEvocatedToLiveWithUrl:(NSURL *)url;
@end

@interface AppCommondCenter : NSObject

@property BOOL hasLogin;

@property (nonatomic,strong)MedLiveUserModel *currentUser;

@property (weak) id<ThirdPlatDelegate> evocateDelegate;
+ (instancetype)sharedCenter;

- (void)fetchUserInfo:(NSString *)uid;

- (void)updateUserInfo:(MedLiveUserModel *)newUser;

- (void)loginWithUid:(NSString *)uid;

- (void)logout;
@end

NS_ASSUME_NONNULL_END
