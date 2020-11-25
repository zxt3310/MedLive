//
//  SKLLiveCreateViewModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/6.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLLiveCreateViewModel.h"
#import "MedCreateLiveRequest.h"
#import "MedUploadPhotoRequest.h"

@implementation SKLLiveCreateViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createLivePlanWithTitle:(NSString *)title Desc:(NSString *)description Uid:(NSString *)uid Start:(NSString *)start picUrl:(NSString *)url Complete:(void(^)(NSString *channelId,NSString *title,NSString *roomId))success{
    MedCreateLiveRequest *request = [[MedCreateLiveRequest alloc] initWithTitle:title Desc:description Uid:uid Start:start picUrl:url Type:@"boardcast" Password:@"" AllowDoc:NO Docs:@""];
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

- (void)uploadPictures:(NSArray <UIImage*> *)imageSet success:(void (^)(NSString *,UIImage* ))success fail:(void(^)(void))fail finaly:(void(^)(int suc,int failure)) finish{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t uploadQueue = dispatch_queue_create("com.saikang.multiupload",DISPATCH_QUEUE_SERIAL);
    __block int suc = 0;
    __block int failure = 0;
    for (UIImage *img in imageSet) {
        dispatch_group_enter(group);
        dispatch_async(uploadQueue, ^{
            [self uploadPicture:img CompleteBlock:^(NSString * _Nonnull picUrl) {
                success(picUrl,img);
                suc++;
                dispatch_group_leave(group);
            } fail:^{
                fail();
                failure++;
                dispatch_group_leave(group);
            }];
        });
    }
    dispatch_group_notify(group,dispatch_get_main_queue(),^{
        finish(suc,failure);
    });
}
@end
