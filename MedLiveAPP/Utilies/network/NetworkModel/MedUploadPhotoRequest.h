//
//  MedUploadPhotoRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/9.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedUploadPhotoRequest : MedBaseRequest
- (instancetype)initWithImage:(UIImage *)photo;
- (void)uploadWithComplete:(void(^)(NSString *picUrl))success fail:(void(^)(void))fail;
- (instancetype)initWithFileData:(NSData *)fileData FileName:(NSString *)fileName FileUrl:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
