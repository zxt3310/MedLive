//
//  MedUploadPhotoRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/9.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedUploadPhotoRequest.h"

@implementation MedUploadPhotoRequest
{
    UIImage *image;
}
- (instancetype)initWithImage:(UIImage *)photo
{
    self = [super init];
    if (self) {
        image = photo;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api/upload/img?type=img";
}

- (void)uploadWithComplete:(void(^)(NSString *picUrl))success fail:(void(^)(void))fail{
    [self startUploadImage:image success:^(MedUploadPhotoRequest *request) {
        NSDictionary *dic = request.responseObject;
        NSString *urlStr = dic[@"data"][@"fileurl"];
        success(urlStr);
    } failure:^(MedUploadPhotoRequest *request) {
        fail();
    }];
}
@end
