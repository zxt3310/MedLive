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
#import <AgoraMediaPlayer/AgoraMediaPlayer.h>

NSString *const SKLMessageSignal_VideoGrant = @"video_grant";
NSString *const SKLMessageSignal_VideoDenied = @"video_denied";
NSString *const SKLMessageSignal_Pointmain = @"point_main";

@interface ViewController ()<LiveManagerRemoteCanvasProvideDelegate,RenderMaseDelegate,SignalDelegate,AgoraMediaPlayerDelegate>
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
    BOOL showBar;
    
    //上麦状态位
    BOOL enableCamara;
    BOOL enableMic;
    BOOL isFirst;
    
    //回放视频url
    NSString *backPlayUrl;
    AgoraMediaPlayer *player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态位初始化
    enableCamara = NO;
    enableMic = NO;
    isFirst = YES;
    
    //加载通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RTMDidReceiveSignal:) name:RTMEngineDidReceiveSignal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LiveShouldPlayBackVideo) name:MedLiveHistoryBackPlay object:nil];
    
    viewModel = [[MedLiveWatchViewModel alloc] init];
    viewModel.signalDelegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViewArea];
    [self setupLocalVideo];
    
    [viewModel fetchRoomInfo:self.roomId Complete:^(MedLiveRoomBoardcast * room) {
        if (![room isMemberOfClass:[MedLiveRoomBoardcast class]]) {
            NSLog(@"无效的直播房间");
            [MedLiveAppUtilies showErrorTip:@"无效的房间号"];
            return;
        }
        
        //加载直播介绍
        [interactView setupIntorduceScroll];
        
        //保存房间  展示标题
        self.channelId = room.channelId;
        [pushView fillTitle:room.roomTitle];
        //如果直播未开始，倒计时
        if (room.status == MedLiveRoomStateCreated) {
            [pushView showPlaceView:YES Start:room.startTime State:room.status coverPic:room.coverPic];
        }
        //如果直播已经结束
        if(room.status == MedLiveRoomStateEnd){
            [pushView showPlaceView:YES
                              Start:nil
                              State:room.backVideoPath?MedLiveRoomStateEndAndBackplay : MedLiveRoomStateEnd
                           coverPic:room.coverPic];
            self->backPlayUrl = room.backVideoPath;
        }else{
            [pushView showPlaceView:YES Start:nil State:room.status coverPic:room.coverPic];
            [self getStart];
        }
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

- (void)getStart{
    //必须在初始化时调用，不然远端流不会接收
    [liveManager enableVideo];
    //直播状态下 初始禁用摄像头 禁用麦克
    [liveManager disableLocalCamera:NO];
    
    MedChannelTokenRequest *req = [[MedChannelTokenRequest alloc] initWithRoomId:self.channelId Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    __weak typeof(self) weakSelf = self;
    __weak MedLiveWatchViewModel *weakModel = viewModel;
    [req startWithSucBlock:^(NSString * _Nonnull token) {
        [self->liveManager joinRoomByToken:token
                                      Room:weakSelf.channelId
                                       Uid:[AppCommondCenter sharedCenter].currentUser.uid success:^{
            //改变状态
            [weakModel changeRoleState:MedLiveRoleStateJoin];
            //拉取频道属性
            [weakModel getAttrbuite];
        }];
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
    if (pushView.uid == uid) {
        MedLiveRoomBoardcast *room = [viewModel valueForKey:@"boardRoom"];
        [pushView showPlaceView:NO Start:nil State:MedLiveRoomStateStart coverPic:room.coverPic];
        return;
    }
    //首次加载
    if (pushView.uid == 0) {
        pushView.uid = uid;
        [liveManager setupVideoRemoteView:pushView];
        [pushView showPlaceView:NO Start:nil State:MedLiveRoomStateStart coverPic:nil];
    }else{
        __weak LiveManager *weakManager = liveManager;
        [pushView addRemoteStream:uid result:^(__kindof LiveView *remoteView) {
            if(remoteView){
                [weakManager setupVideoRemoteView:remoteView];
            }
        }];
    }
}

- (void)didRemoteLeave:(NSInteger)uid{
    if (uid == pushView.uid) {
        MedLiveRoomBoardcast *room = [viewModel valueForKey:@"boardRoom"];
        [MedLiveAppUtilies showErrorTip:@"主播已下播"];
        [pushView showPlaceView:YES Start:room.startTime State:room.status coverPic:room.coverPic];
    }else{
        [pushView removeRemoteStream:uid];
    }
}

- (void)tokenWillExpireRetake:(void (^)(NSString * _Nonnull))fetchToken{
    MedChannelTokenRequest *request = [[MedChannelTokenRequest alloc] initWithRoomId:self.roomId
                                                                                 Uid:[AppCommondCenter sharedCenter].currentUser.uid];
    [request startWithSucBlock:^(NSString * _Nonnull token) {
        fetchToken(token);
    }];
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

#pragma mark RenderMaskDelegate Imp
- (void)RenderMaskDidSwitchPlayStateComplate:(void (^)(MedLiveState))block{
    static MedLiveState originState = MedLiveStatePlaying;
    //播放器状态就不管直播了
    if (player) {
        if (originState == MedLiveStatePlaying) {
            [player pause];
            originState = MedLiveStatePausing;
        }else{
            if (player.state == AgoraMediaPlayerStatePlayBackCompleted) {
                [player seekToPosition:1];
            }else{
                [player play];
            }
            originState = MedLiveStatePlaying;
        }
        block(originState);
        return;
    }
    
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
        //离开视频流频道
        [liveManager leaveRoom];
        //状态
        [viewModel changeRoleState:MedliveRoleStateLeave];
        //离开聊天
        [viewModel leaveRtmChannel];
        //销毁播放器
        if (player) {
            [player destroy];
            player = nil;
        }
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

- (void)switchCamara:(void (^)(BOOL,BOOL))res{
    enableCamara = !enableCamara;
    if (isFirst) {
        __weak LiveManager *weakManager = liveManager;
        if (pushView.uid != [AppCommondCenter sharedCenter].currentUser.uid.integerValue) {
            [pushView addRemoteStream:[AppCommondCenter sharedCenter].currentUser.uid.integerValue result:^(LiveView * view) {
                [weakManager setupVideoLocalView:view];
                [weakManager disableLocalCamera:YES];
            }];
        }
        [liveManager disableLocalCamera:enableCamara];
        [pushView showPlaceView:NO Start:nil State:MedLiveRoomStateStart coverPic:nil];
        //第一次开启摄像头时，会强制开麦，如果麦克已经开启，则先将麦克状态位复原，再触发开麦，便于走通联动逻辑
        enableMic = NO;
        res(enableCamara,isFirst);
        isFirst = NO;
    }else{
        if (pushView.uid == [AppCommondCenter sharedCenter].currentUser.uid.integerValue) {
            if (!enableCamara) {
                [pushView showPlaceView:YES Start:nil State:MedLiveRoomStateNoCamara coverPic:nil];
            }else{
                [pushView showPlaceView:NO Start:nil State:MedLiveRoomStateStart coverPic:nil];
            }
        }
        [liveManager disableLocalCamera:enableCamara];
        res(enableCamara,isFirst);
    }
    
    [pushView remote:[AppCommondCenter sharedCenter].currentUser.uid.integerValue DidEnabledCamara:enableCamara];
    
}

- (void)switchMic:(void (^)(BOOL))res{
    enableMic = !enableMic;
    [liveManager muteLocalMic:!enableMic];
    res(enableMic);
}

- (void)remote:(NSInteger)uid DidDisabledCamera:(BOOL)disable{
    if (uid == pushView.uid) {
        [pushView showPlaceView:disable Start:nil State:MedLiveRoomStateNoCamara coverPic:nil];
    }else{
        [pushView remote:uid DidEnabledCamara:!disable];
    }
}



#pragma Signal Notification
//备用
- (void)RTMDidReceiveSignal:(NSNotification *)notify{
//    MedChannelSignalMessage *signal = (MedChannelSignalMessage *)notify.object;
//    if ([signal.targetid isEqualToString:[AppCommondCenter sharedCenter].currentUser.uid]) {
//        if ([signal.signal isEqualToString:SKLMessageSignal_VideoGrant]) {
//            [pushView enableSideBar:YES];
//        }
//
//        if ([signal.signal isEqualToString:SKLMessageSignal_VideoDenied]) {
//            isFirst = YES;
//            [pushView enableSideBar:NO];
//            [liveManager disableVideo];
//            [pushView removeRemoteStream:signal.targetid.integerValue];
//        }
//    }else{
//        if ([signal.signal isEqualToString:SKLMessageSignal_Pointmain]) {
//            //如果目标是自己，说明
//            if ([signal.targetid isEqualToString:[AppCommondCenter sharedCenter].currentUser.uid]) {
//
//            }
//            //纯拉流
//            else{
//                NSInteger curId = pushView.uid;
//                if(curId != signal.targetid.integerValue){
//                    pushView.uid = signal.targetid.integerValue;
//                    //移除小窗口
//                    [pushView removeRemoteStream:signal.targetid.integerValue];
//                    //加载大窗口
//                    [pushView renewVideoView];
//                    [liveManager setupVideoRemoteView:pushView];
//
//                    //重新放置小窗口
//                    __weak LiveManager *weakManager = liveManager;
//                    [pushView addRemoteStream:curId result:^(__kindof LiveView * view) {
//                        [weakManager setupVideoRemoteView:view];
//                    }];
//                }
//            }
//        }
//    }
}

- (void)renewMainPoint:(NSInteger )targetId{
    NSInteger curId = pushView.uid;
    pushView.uid = targetId;
    //移除小窗口
    [pushView removeRemoteStream:targetId];
    //加载大窗口
    [pushView renewVideoView];
    if (targetId == [AppCommondCenter sharedCenter].currentUser.uid.integerValue) {
        [liveManager setupVideoLocalView:pushView];
    }else{
        [liveManager setupVideoRemoteView:pushView];
    }
    
    //重新放置小窗口
    __weak LiveManager *weakManager = liveManager;
    [pushView addRemoteStream:curId result:^(__kindof LiveView * view) {
        if (curId == [AppCommondCenter sharedCenter].currentUser.uid.integerValue) {
            [weakManager setupVideoLocalView:view];
        }else{
            [weakManager setupVideoRemoteView:view];
        }
    }];
}

#pragma mark 处理信令新协议通知
//收到上麦邀请
- (void)RTMDidReceiveVideoGrantRes:(void(^)(BOOL succesed))success{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"通知" message:@"主播邀请您上麦,点击“接受”自动开启摄像头,“忽略”可由您自行操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用非公开函数
        [pushView performSelector:@selector(deviceOnForce)];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirm];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:^{
        [liveManager setRole:AgoraClientRoleBroadcaster];
        [pushView enableSideBar:YES];
    }];
    success(YES);
}
//收到下麦通知
- (void)RTMDidReceiveVideoDeniedRes:(void(^)(BOOL succesed))success{
    [liveManager setRole:AgoraClientRoleAudience];
    [liveManager disableLocalCamera:NO];
    [liveManager muteLocalMic:YES];
    
    [pushView enableSideBar:NO];
    enableCamara = NO;
    enableMic = NO;
    isFirst = YES;
    [pushView removeRemoteStream:[AppCommondCenter sharedCenter].currentUser.uid.integerValue];
    [MedLiveAppUtilies showErrorTip:@"您已被主播下麦"];
    success(YES);
}
//收到主讲人通知
- (void)RTMDidReceivePointMain:(NSInteger) targetId res:(void(^)(BOOL succesed))success{
    if (targetId == 0) {
        success(YES);
        return;
    }
    //如果主窗口已经是目标 则忽略
    if (targetId && targetId == pushView.uid) {
        success(YES);
        return;
    }
    [self renewMainPoint:targetId];
    success(NO);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets safeArea = self.view.safeAreaInsets;
    [interactView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-safeArea.bottom);
    }];
}


#pragma mark 直播回放
- (void)LiveShouldPlayBackVideo{
    [pushView showPlaceView:NO Start:nil State:MedLiveRoomStateEndAndBackplay coverPic:nil];
    player = [[AgoraMediaPlayer alloc] initWithDelegate:self];
    [player setRenderMode:AgoraMediaPlayerRenderModeHidden];
    [player setView:pushView.videoView];
    [player open:backPlayUrl startPos:0];
}

- (void)AgoraMediaPlayer:(AgoraMediaPlayer *)playerKit didChangedToPosition:(NSInteger)position{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [pushView playingTrack:position];
    });
}
- (void)AgoraMediaPlayer:(AgoraMediaPlayer *)playerKit didChangedToState:(AgoraMediaPlayerState)state error:(AgoraMediaPlayerError)error{
    if (state == AgoraMediaPlayerStateOpenCompleted && state != AgoraMediaPlayerStatePlaying) {
        NSInteger length = [player getDuration];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [pushView installVideoSliderBarWithVideoLength:length];
        });
        [player play];
    }

    if (state == AgoraMediaPlayerStatePlayBackCompleted) {
        NSLog(@"播完了");
    }
}

- (void)AgoraMediaPlayer:(AgoraMediaPlayer *)playerKit didOccurEvent:(AgoraMediaPlayerEvent)event{
    
}
#pragma mark 播放器 进度条 action
- (void)videoSliderDidJump:(NSInteger)point{
    [player seekToPosition:point];
}
                          
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"controller dealloc ok!");
}
@end
