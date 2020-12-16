//
//  SKLUserInfoViewModel.h
//  MedLiveAPP
//
//  Created by zxt on 2020/12/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKLUserInfoViewModel : NSObject
- (void)fetchInfoWithComplete:(void(^)(MedLiveUserModel *user))res;
- (void)updateInfoWithName:(NSString *)name complete:(void(^)(void))res;
- (void)updateInfoWithHeadUrl:(NSString *)url complete:(void(^)(void))res;
- (void)uploadHeaderImg:(UIImage *)img complete:(void(^)(void))res;
@end

NS_ASSUME_NONNULL_END
