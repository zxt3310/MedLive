//
//  MedLiveRoom.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveRoom : NSObject <YYModel>
@property NSString *channelId;
@property NSString *roomId;
@property NSString *owner;
@property NSString *type;
@property NSString *startTime;
@property NSString *endTime;
@property NSString *roomTitle;
@property NSInteger status;
@property NSInteger favor;
@end

NS_ASSUME_NONNULL_END
