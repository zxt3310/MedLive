//
//  MedLiveRoomMeetting.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveRoomMeetting : MedLiveRoom
@property NSString *password;
@property NSInteger allowDoc;
@property NSString *docsJson;
@end

NS_ASSUME_NONNULL_END
