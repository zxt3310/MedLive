//
//  MedLiveUserModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveUserModel.h"
#import <YYModel.h>

NSString *const LOCALUSERINFO_STORAGE_KEY = @"LoginUserInfo_LocalStorage";
NSString *const MED_USER_NORMAL = @"user";
NSString *const MED_USER_DOCTOR = @"doctor";

@interface MedLiveUserModel()<YYModel,NSSecureCoding>

@end

@implementation MedLiveUserModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uid = @"0";
        self.userType = MED_USER_NORMAL;
    }
    return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self yy_modelInitWithCoder:coder];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self yy_modelEncodeWithCoder:coder];
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"uid":@"id",
        @"userName":@"true_name",
        @"wxId":@"wx_open_id",
        @"mobile":@"mobile",
        @"userType":@"user_type",
        @"headerImgUrl":@"cover_pic",
        @"registTime":@"created_at",
        @"updateTime":@"updated_at",
        @"doctorAuditState":@"is_audit",
        @"doctorInfo":@"doctor_info"
    };
}


- (void)save{
    NSError *err;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:&err];
    if (err) {
        NSLog(@"%@",err.description);
    }
    if (userData) {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:LOCALUSERINFO_STORAGE_KEY];
    }
}

+ (instancetype)loadFromUserDefaults{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:LOCALUSERINFO_STORAGE_KEY];
    if (userData) {
        NSError *err;
        MedLiveUserModel *user = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:userData error:&err];
        if (err) {
            NSLog(@"%@",err.description);
        }
        if (user) {
            return user;
        }
    }
    return [[[self class] alloc] init];
}


- (void)dealloc
{
    NSLog(@"用户资料已更新");
}

@end


@interface MedDoctorModel() <YYModel,NSSecureCoding>

@end

@implementation MedDoctorModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"uid":@"id",
        @"name":@"name",
        @"hospitalId":@"hospital_id",
        @"title":@"job_title",
        @"skill":@"skill",
        @"desc":@"desc",
        @"departId":@"depart_id",
        @"coverPic":@"cover_pic",
        @"idCardFrontPic":@"cover_pic1",
        @"idCardBackPic":@"cover_pic2",
        @"skillPic":@"cover_pic3",
        @"degreePic":@"cover_pic4",
        @"createTime":@"created_at",
        @"doctorAuditState":@"is_audit"
    };
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self yy_modelInitWithCoder:coder];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self yy_modelEncodeWithCoder:coder];
}

@end
