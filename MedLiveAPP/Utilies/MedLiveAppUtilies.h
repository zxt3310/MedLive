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
+ (BOOL) checkTelNumber:(NSString *)telNumber;
@end

@interface NSString(ex)
+ (BOOL)isBlankString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END

