//
//  MedLiveUserModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const LOCALUSERINFO_STORAGE_KEY;

@interface MedLiveUserModel : NSObject
@property NSString *uid;
@property NSString *userName;
@property NSString *mobile;
+ (instancetype)loadFromUserDefaults;
- (void)save;
@end

NS_ASSUME_NONNULL_END
