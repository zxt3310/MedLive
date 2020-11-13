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

@interface ViewController ()<LiveManagerRemoteCanvasProvideDelegate,RenderMaseDelegate>
@end

@implementation ViewController
{
    LiveVideoRenderView *pushView;
    UIView *pullView;
    UIView *optionBar;
    LiveManager *liveManager;
    AgoraRtcVideoCanvas *localArea;
    AgoraRtcVideoCanvas *remoteArea;
    NSString *roomId;
    NSString *roleName;
    NSMutableArray<UIView *> *videoCollection;
    BOOL showBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    roomId = @"zxt";
    roleName = @"zxt";
    videoCollection = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViewArea];
    [self setupLocalVideo];
    [self getStart];
}

- (void)setupViewArea{
    
    pushView = [[LiveVideoRenderView alloc] initWithMaskDelegate:self];
    
    pushView.layer.borderWidth = 1;
    
    [self.view addSubview:pushView];
    
    [pushView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@300);
    }];
}

- (void)getStart{
    [liveManager enableVideo];
    MedChannelTokenRequest *req = [[MedChannelTokenRequest alloc] initWithRoomId:self.channelId Uid:@"0"];
    __weak typeof(self) weakSelf = self;
    [req startWithSucBlock:^(NSString * _Nonnull token) {
        [self->liveManager joinRoomByToken:token Room:weakSelf.channelId Uid:[AppCommondCenter sharedCenter].currentUser.uid];
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

}

- (void)didRemoteLeave:(NSInteger)uid{
    void (^callback)(UIView *) = ^(UIView *view){
        [view removeFromSuperview];
        [self->videoCollection removeObject:view];
        view = nil;
    };
    for(UIView* view in videoCollection){
        NSInteger a = [[view valueForKey:@"uid"] integerValue];
        if(a == uid){
            callback(view);
            break;
        }
    }
}

- (void)viewDidLayoutSubviews{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        UIEdgeInsets insets = self.view.safeAreaInsets;
//        CGRect temp = optionBar.frame;
//        temp.origin.y += insets.top;
//        optionBar.frame = temp;
//    });
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
    }
}
    
- (void)dealloc{
    [liveManager leaveRoom];
    NSLog(@"controller dealloc ok!");
}

@end
