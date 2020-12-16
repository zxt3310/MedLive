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
NSString *const MED_USER_NORMAL = @"user_normal";
NSString *const MED_USER_DOCTOR = @"user_doctor";

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

- (void)setWithDictionary:(NSDictionary *)dic{
    self.uid = [[dic objectForKey:@"id"] stringValue];
    self.mobile = Kstr((NSString *)[dic objectForKey:@"mobile"]);
    self.userName = Kstr((NSString *)[dic objectForKey:@"true_name"]);
    self.userType = Kstr((NSString *)[dic objectForKey:@"user_type"]);
    self.headerImgUrl = Kstr((NSString *)[dic objectForKey:@"cover_pic"]);
    
    [self save];
}

- (void)save{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
    if (userData) {
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:LOCALUSERINFO_STORAGE_KEY];
    }
}

+ (instancetype)loadFromUserDefaults{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:LOCALUSERINFO_STORAGE_KEY];
    if (userData) {
        MedLiveUserModel *user = [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:userData error:nil];
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
