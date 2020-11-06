//
//  MedLiveController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveController.h"
#import "MedBordcastView.h"
#import "MedLiveViewModel.h"

@interface MedLiveController ()<BordcastViewDelegate>
{
    MedLiveViewModel *viewModel;
}
@end

@implementation MedLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewModel = [[MedLiveViewModel alloc] init];
    
    MedBordcastView *bordView = [[MedBordcastView alloc] init];
    bordView.bordcastDelegate = self;
    self.view = bordView;
    
    [viewModel setupLocalView:bordView];
    [viewModel createRoomWithTitle:self.titleName Description:@"" Complate:^(NSString * _Nonnull chanlId, NSString * _Nonnull chanlToken, NSString * _Nonnull roomID) {
        int isJoin = [self->viewModel joinChannel:chanlId Token:chanlToken];
        if (isJoin != 0) {
            
        }
    }];
}


- (void)bordcastViewDidEnd{
    [viewModel stopLive];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
}

@end
