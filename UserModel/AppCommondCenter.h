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

@interface AppCommondCenter : NSObject

@property MedLiveUserModel *currentUser;

+ (id)sharedCenter;

@end

NS_ASSUME_NONNULL_END
