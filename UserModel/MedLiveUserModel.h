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
UIKIT_EXTERN NSString *const MED_USER_NORMAL;
UIKIT_EXTERN NSString *const MED_USER_DOCTOR;

@interface MedLiveUserModel : NSObject
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *userType;
@property (nonatomic,strong) NSString *headerImgUrl;

+ (instancetype)loadFromUserDefaults;

- (void)setWithDictionary:(NSDictionary *)dic;

- (void)save;
@end

NS_ASSUME_NONNULL_END
