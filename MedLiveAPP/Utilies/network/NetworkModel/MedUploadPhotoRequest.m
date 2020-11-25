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
    NSData *fileData;
    NSURL *urlLocalStr;
    NSString *fileName;
}
- (instancetype)initWithImage:(UIImage *)photo
{
    self = [super init];
    if (self) {
        image = photo;
    }
    return self;
}

- (instancetype)initWithFileData:(NSData *)fileData FileName:(NSString *)fileName FileUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        self->fileData = fileData;
        self->fileName = fileName;
        urlLocalStr = url;
    }
    return self;
}

- (NSString *)requestUrl{
    return @":8081/api/saikang/upload/img?type=img";
}

- (void)uploadWithComplete:(void(^)(NSString *picUrl))success fail:(void(^)(void))fail{
    if (image) {
        [self startUploadImage:image success:^(MedUploadPhotoRequest *request) {
            NSDictionary *dic = request.responseObject;
            NSString *urlStr = dic[@"data"][@"fileurl"];
            success(urlStr);
        } failure:^(MedUploadPhotoRequest *request) {
            fail();
        }];
    }else if(fileData && fileName && urlLocalStr){
        [self startUploadFile:urlLocalStr Data:fileData FileName:fileName success:^(MedBaseRequest *request) {
            NSDictionary *dic = request.responseObject;
            NSString *urlStr = dic[@"data"][@"fileurl"];
            success(urlStr);
        } failure:^(MedBaseRequest *request) {
            fail();
        }];
    }
    
}
@end
