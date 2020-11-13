//
//  MedLiveAppUtilies.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/5.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveAppUtilies : NSObject
+ (void)checkForm:(NSArray <NSString *> *)formAry Aleart:(NSArray <NSString *>*)alearAry Complate:(void(^)(bool, NSString * _Nullable))result;
+ (BOOL) checkTelNumber:(NSString *)telNumber;
+ (BOOL)needLogin;
@end

@interface NSString(ex)
+ (BOOL)isBlankString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END

