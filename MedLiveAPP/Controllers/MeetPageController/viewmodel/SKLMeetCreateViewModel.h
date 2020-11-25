//
//  SKLMeetCreateViewModel.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/23.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKLMeetCreateViewModel : NSObject
- (void)createLivePlanWithTitle:(NSString *)title Uid:(NSString *)uid Start:(NSString *)start Password:(NSString *)pwd allowDocs:(BOOL)allow Docs:(NSString*)docs Complete:(void(^)(NSString *channelId,NSString *title,NSString *roomId))success;

- (void)uploadPicture:(UIImage *)image CompleteBlock:(void(^)(NSString *picUrl)) success fail:(void(^)(void))fail;
- (void)uploadFile:(NSData *)fileData Name:(NSString *)fileName FileUrl:(NSURL *)url success:(void(^)(NSString *picUrl)) success;
@end

NS_ASSUME_NONNULL_END
