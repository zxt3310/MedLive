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

typedef enum : NSUInteger {
    DocAuditStateIng,
    DocAuditStateDone,
    DocAuditStateDiend,
} DocAuditState;

@class MedDoctorModel;

@interface MedLiveUserModel : NSObject
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *wxId;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *userType;
@property (nonatomic,strong) NSString *headerImgUrl;
@property (nonatomic,strong) NSString *registTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic) DocAuditState doctorAuditState;
@property (nonatomic,strong) MedDoctorModel *doctorInfo;


+ (instancetype)loadFromUserDefaults;

//- (void)setWithDictionary:(NSDictionary *)dic;

- (void)save;
@end


@interface MedDoctorModel : NSObject
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSInteger hospitalId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *skill;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic) NSInteger departId;
@property (nonatomic,strong) NSString *coverPic;
@property (nonatomic,strong) NSString *idCardFrontPic;
@property (nonatomic,strong) NSString *idCardBackPic;
@property (nonatomic,strong) NSString *skillPic;
@property (nonatomic,strong) NSString *degreePic;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic) DocAuditState doctorAuditState;
@end

NS_ASSUME_NONNULL_END
