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

#define tempToken @"006269ff1d0fecd46b783132c2bda90fc66IACoQu/y3RwLae4W3cXL+YX/MmujhXpmsI/vzRwume5s009yqRYAAAAAEAA1HXOdk2KJXwEAAQCTYolf"

@interface ViewController ()<LiveManagerRemoteCanvasProvideDelegate>
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
    [self setupOptionBar];
    [self setupLocalVideo];
}

- (void)setupViewArea{
    
    pushView = [[LiveVideoRenderView alloc] init];
    
    pushView.layer.borderWidth = 1;
    pullView.layer.borderWidth = 1;
    
    [self.view addSubview:pushView];
}

- (void)setupOptionBar{
    optionBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setFrame:CGRectMake(320, 25, 60, 30)];
    [start setTitle:@"直播" forState:UIControlStateNormal];
    [start setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:1.0 alpha:1]];
    [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [start addTarget:self action:@selector(getStart) forControlEvents:UIControlEventTouchUpInside];
    [optionBar addSubview:start];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchBtn setFrame:CGRectMake(230, 25, 60, 30)];
    [switchBtn setTitle:@"切换" forState:UIControlStateNormal];
    [switchBtn setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:1.0 alpha:1]];
    [switchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchArea) forControlEvents:UIControlEventTouchUpInside];
    [optionBar addSubview:switchBtn];
    
    [self.view addSubview:optionBar];
}

- (void)getStart{
//    [liveManager enableVideo];
//    [liveManager setupVideoLocalView:localArea];
//    [liveManager joinRoomByToken:tempToken Room:roomId];
    showBar = !showBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)switchArea{
    id appDelegate = [UIApplication sharedApplication].delegate;
    NSNumber *value = [appDelegate valueForKey:@"_allowRotation"];
    BOOL rotation = value.boolValue;
    NSNumber *newValue = [NSNumber numberWithBool:!rotation];
    [appDelegate setValue:newValue forKey:@"_allowRotation"];
    [self setNewOrientation:newValue.boolValue];
}

-(void)setupLocalVideo{
    liveManager = [[LiveManager alloc] init];
    liveManager.provideDelegate = self;
    liveManager.role = AgoraClientRoleBroadcaster;
    
    localArea = [[AgoraRtcVideoCanvas alloc] init];
    localArea.uid = 0;
    localArea.view = pushView;
    localArea.renderMode = AgoraVideoRenderModeHidden;
}

- (void)didAddRemoteMember:(UIView *)view{
    NSInteger count = videoCollection.count;
    CGRect frame = CGRectMake(self.view.bounds.size.width - 100 * (count+1) - 10*count
                              , self.view.bounds.size.height - 200, 100, 150);
    [view setFrame:frame];
    [videoCollection addObject:view];
    [self.view addSubview:view];
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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIEdgeInsets insets = self.view.safeAreaInsets;
        CGRect temp = optionBar.frame;
        temp.origin.y += insets.top;
        optionBar.frame = temp;
    });
    
    [pushView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@300);
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

@end
