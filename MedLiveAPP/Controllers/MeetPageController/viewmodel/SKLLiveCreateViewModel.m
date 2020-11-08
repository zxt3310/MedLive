//
//  SKLLiveCreateViewModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/6.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLLiveCreateViewModel.h"
#import "MedCreateLiveRequest.h"

@implementation SKLLiveCreateViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createLivePlanWithTitle:(NSString *)title Desc:(NSString *)description Uid:(NSString *)uid Start:(NSString *)start picUrl:(NSString *)url Complete:(void(^)(NSString *channelId,NSString *title,NSString *roomId))success{
    MedCreateLiveRequest *request = [[MedCreateLiveRequest alloc] initWithTitle:title Desc:description Uid:uid Start:start picUrl:url];
    [request startWithSucBlock:^(NSString * channelId, NSString * title, NSString * roomId) {
        success(channelId,title,roomId);
    }];
}

@end
