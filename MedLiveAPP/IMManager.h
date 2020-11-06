//
//  IMManager.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtmKit/AgoraRtmKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface IMManager : NSObject

+ (id)sharedManager;
//登录声网服务器
- (void)loginToAgoraServiceWithId:(NSString *)userId Token:(NSString * _Nullable)token;
@end

NS_ASSUME_NONNULL_END
