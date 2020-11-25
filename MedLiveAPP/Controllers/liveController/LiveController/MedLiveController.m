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
#import "MedLiveRoomBoardcast.h"

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
    
    [viewModel fetchRoomInfo:self.roomId Complete:^(MedLiveRoomBoardcast * res) {
        self.channelId = res.channelId;
        self.titleName = res.roomTitle;
        
        [viewModel createRoomWithTitle:self.title ChannelId:self.channelId Complate:^(NSString *chanlToken) {
            int res = [viewModel joinChannel:self.channelId Token:chanlToken];
            if (res == 0) {
                //发送开播信号
                [viewModel sendLiveState:MedLiveRoomStateStart
                                  RoomId:self.roomId
                                  UserId:[AppCommondCenter sharedCenter].currentUser.uid];
            }
        }];
    }];
}


- (void)bordcastViewDidEnd{
    [viewModel stopLive];
    //发送下播信号
    [viewModel sendLiveState:MedLiveRoomStateEnd
                      RoomId:self.roomId
                      UserId:[AppCommondCenter sharedCenter].currentUser.uid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    NSLog(@"直播窗体已释放");
}

@end
