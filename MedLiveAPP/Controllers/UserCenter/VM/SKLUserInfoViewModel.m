//
//  SKLUserInfoViewModel.m
//  MedLiveAPP
//
//  Created by zxt on 2020/12/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLUserInfoViewModel.h"
#import "MedLiveFetchUserInfoRequest.h"
#import "MedLiveUpdateUserInfoRequest.h"
#import "MedUploadPhotoRequest.h"
#import <YYModel.h>

@implementation SKLUserInfoViewModel

- (void)fetchInfoWithComplete:(void(^)(MedLiveUserModel *user))res{
    MedLiveFetchUserInfoRequest *req = [[MedLiveFetchUserInfoRequest alloc] initWithUid:[AppCommondCenter sharedCenter].currentUser.uid];
    [req fetchInfo:^(NSDictionary * infoDic) {
        MedLiveUserModel *user = [MedLiveUserModel yy_modelWithDictionary:infoDic];
        [user save];
        res(user);
    }];
}

- (void)updateInfoWithName:(NSString *)name complete:(void(^)(void))res{
    MedLiveUpdateUserInfoRequest *req = [[MedLiveUpdateUserInfoRequest alloc] initWithName:name
                                                                                       Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    [req startUpdate:^{
        MedLiveUserModel *user = [AppCommondCenter sharedCenter].currentUser;
        user.userName = name;
        [[AppCommondCenter sharedCenter] updateUserInfo:user];
        res();
    }];
}

- (void)updateInfoWithHeadUrl:(NSString *)url complete:(void(^)(void))res{
    MedLiveUpdateUserInfoRequest *req = [[MedLiveUpdateUserInfoRequest alloc] initWithHeaderUrl:url
                                                                                            Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    [req startUpdate:^{
        MedLiveUserModel *user = [AppCommondCenter sharedCenter].currentUser;
        user.headerImgUrl = url;
        [[AppCommondCenter sharedCenter] updateUserInfo:user];
        res();
    }];
}

- (void)uploadHeaderImg:(UIImage *)img complete:(void (^)(void))res{
    MedUploadPhotoRequest *req = [[MedUploadPhotoRequest alloc] initWithImage:img];
    [req uploadWithComplete:^(NSString *picUrl) {
        [self updateInfoWithHeadUrl:picUrl complete:^{
            res();
        }];
    } fail:^{
        
    }];
}

@end
