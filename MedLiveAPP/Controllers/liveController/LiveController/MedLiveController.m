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
#import <LGAlertView.h>

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
            [viewModel joinChannel:self.channelId Token:chanlToken];
        }];
    }];
}


- (void)bordcastViewDidEnd{
    LGAlertView *alert = [LGAlertView alertViewWithTitle:@"退出直播"
                                                  message:@"主播退出,直播即结束"
                                                   style:LGAlertViewStyleAlert
                                            buttonTitles:@[@"确定"]
                                       cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil];
    alert.messageTextColor = [UIColor redColor];
    
    __weak MedLiveViewModel *weakModel = viewModel;
    WeakSelf
    alert.actionHandler= ^(LGAlertView *alertView, NSUInteger index, NSString *title){
        [weakModel stopLive];
        //发送下播信号
        [weakModel sendLiveState:MedLiveRoomStateEnd
                          UserId:[AppCommondCenter sharedCenter].currentUser.uid];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [alert showAnimated];
}

- (void)dealloc{
    NSLog(@"直播窗体已释放");
}

@end
