//
//  SKLMeetCreateViewModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/23.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMeetCreateViewModel.h"
#import "MedCreateLiveRequest.h"
#import "MedUploadPhotoRequest.h"

@implementation SKLMeetCreateViewModel
- (void)createLivePlanWithTitle:(NSString *)title Uid:(NSString *)uid Start:(NSString *)start Password:(NSString *)pwd allowDocs:(BOOL)allow Docs:(NSString*)docs Complete:(void(^)(NSString *channelId,NSString *title,NSString *roomId))success{
   MedCreateLiveRequest *request = [[MedCreateLiveRequest alloc] initWithTitle:title Desc:@"" Uid:uid Start:start picUrl:@"" Type:@"meeting" Password:pwd AllowDoc:allow Docs:docs];
   [request startWithSucBlock:^(NSString * channelId, NSString * title, NSString * roomId) {
       success(channelId,title,roomId);
   }];
}


- (void)uploadPicture:(UIImage *)image CompleteBlock:(void(^)(NSString *picUrl)) success fail:(void(^)(void))fail{
    MedUploadPhotoRequest *request = [[MedUploadPhotoRequest alloc] initWithImage:image];
    [request uploadWithComplete:^(NSString *picUrl){
        success(picUrl);
    } fail:^{
        fail();
    }];
}

- (void)uploadFile:(NSData *)fileData Name:(NSString *)fileName FileUrl:(NSURL *)url success:(void(^)(NSString *picUrl)) success{
    MedUploadPhotoRequest *request = [[MedUploadPhotoRequest alloc] initWithFileData:fileData FileName:fileName FileUrl:url];
    [request uploadWithComplete:^(NSString * fileUrl) {
        success(fileUrl);
    } fail:^{
        
    }];
}
@end
