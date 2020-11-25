//
//  ViewController.m
//  MedLiveAPP
//
//  Created by Zxt on 2020/8/27.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "ViewController.h"
#import "LiveManager.h"
#import "LiveVideoRenderView.h"
#import "MedChannelTokenRequest.h"
#import "MedLiveInteractView.h"
#import "MedLiveWatchViewModel.h"
#import "MedLiveLoginController.h"
#import "MedLiveRoomBoardcast.h"

@interface ViewController ()<LiveManagerRemoteCanvasProvideDelegate,RenderMaseDelegate>
@end

@implementation ViewController
{
    MedLiveWatchViewModel *viewModel;
    LiveVideoRenderView *pushView;
    MedLiveInteractView *interactView;
    UIView *pullView;
    UIView *optionBar;
    LiveManager *liveManager;
    AgoraRtcVideoCanvas *localArea;
    AgoraRtcVideoCanvas *remoteArea;
    NSMutableArray<UIView *> *videoCollection;
    BOOL showBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewModel = [[MedLiveWatchViewModel alloc] init];
    videoCollection = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViewArea];
    [self setupLocalVideo];
    
    [viewModel fetchRoomInfo:self.roomId Complete:^(MedLiveRoomBoardcast * room) {
        self.channelId = room.channelId;
        [pushView fillTitle:room.roomTitle];
        if (room.status == 1) {
            [pushView showPlaceView:YES CenterTip:@"直播未开始"];
        }
        [self getStart];
    }];
    
    
    WeakSelf
    viewModel.pushCall = ^(NSString * _Nonnull callIndentifer) {
        if (callIndentifer == MedLoginCall) {
            [weakSelf.navigationController pushViewController:[[MedLiveLoginController alloc] init] animated:YES];
        }
    };
}

- (void)setupViewArea{
    
    pushView = [[LiveVideoRenderView alloc] initWithMaskDelegate:self];
    [self.view addSubview:pushView];
    
    [pushView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.height.equalTo(@300);
    }];
    
    interactView = [[MedLiveInteractView alloc] initWithViewDelegate:viewModel];
    [self.view addSubview:interactView];
    
    [interactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(pushView.mas_bottom);
    }];
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets safeArea = self.view.safeAreaInsets;
    [interactView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-safeArea.bottom);
    }];
}

- (void)getStart{
    [liveManager enableVideo];
    MedChannelTokenRequest *req = [[MedChannelTokenRequest alloc] initWithRoomId:self.channelId Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    __weak typeof(self) weakSelf = self;
    [req startWithSucBlock:^(NSString * _Nonnull token) {
        [self->liveManager joinRoomByToken:token
                                      Room:weakSelf.channelId
                                       Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    }];
    
}

- (BOOL)isFullScreen{
    id appDelegate = [UIApplication sharedApplication].delegate;
    NSNumber *value = [appDelegate valueForKey:@"_allowRotation"];
    BOOL rotation = value.boolValue;
    return rotation;
}

- (void)switchScreenRotation{
    BOOL rotation = [self isFullScreen];
    NSNumber *newValue = [NSNumber numberWithBool:!rotation];
    [(id)[UIApplication sharedApplication].delegate setValue:newValue forKey:@"_allowRotation"];
    [self setNewOrientation:newValue.boolValue];
}

-(void)setupLocalVideo{
    liveManager = [[LiveManager alloc] init];
    liveManager.provideDelegate = self;
    liveManager.role = AgoraClientRoleAudience;
     
}

- (void)didAddRemoteMember:(NSUInteger) uid{
    pushView.uid = uid;
    [liveManager setupVideoRemoteView:pushView];
    [pushView showPlaceView:NO CenterTip:nil];
}

- (void)didRemoteLeave:(NSInteger)uid{
    if (uid == pushView.uid) {
        NSLog(@"主播下播了");
        [pushView showPlaceView:YES CenterTip:@"主播已下播"];
    }
}

//设定设备屏幕方向
- (void)setNewOrientation:(BOOL)fullscreen{
    if (fullscreen) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }else{
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

- (BOOL)prefersStatusBarHidden{
    return showBar;
}

- (void)changeStatusBar:(BOOL)disappear{
    showBar = disappear;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)RenderMaskDidSwitchPlayStateComplate:(void (^)(MedLiveState))block{
    static MedLiveState originState = MedLiveStatePlaying;
    originState = [liveManager pauseOrPlay:originState];
    block(originState);
}

- (void)RenderMaskDidSwitchScreenStateComplate{
    [self switchScreenRotation];
    [pushView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)RenderMasekDidTapBack:(void (^)(MedLiveScreenState))block{
    if(![self isFullScreen]){
        block(999);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self switchScreenRotation];
        [pushView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.height.equalTo(@300);
        }];
        block(MedLiveScreenStateNormal);
        [interactView resetScroll];
    }
}
    
- (void)dealloc{
    [liveManager leaveRoom];
    [viewModel leaveRtmChannel];
    NSLog(@"controller dealloc ok!");
}
@end
