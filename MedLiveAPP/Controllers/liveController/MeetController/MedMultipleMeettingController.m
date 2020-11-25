//
//  MedMultipleMeettingController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedMultipleMeettingController.h"
#import "MutipleMeettingViewModel.h"
#import "MutipleView.h"
#import "MedLiveRoomMeetting.h"

#define HoritonSpace 5.0
#define VerticalSpace 5.0

@interface MedMultipleMeettingController ()<MedMutipleMeetingDelegate>

@end

@implementation MedMultipleMeettingController
{
    FlexScrollView *containor;
    MutipleMeettingViewModel *viewModel;
    NSMutableArray <MutipleView*> *memberAry; //参会人员视图
    UIView *streamView;
    
    UIImageView *micOnImg;
    UIImageView *micOffImg;
    UIImageView *cameraOnImg;
    UIImageView *cameraOffImg;
    
    UILabel *micLabel;
    UILabel *cameraLabel;
    UIView *toolsView;
    
    UILabel *memberCountLabel;//频道人员计数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view enableFlexLayout:YES];
    memberAry = [NSMutableArray array];
    
    viewModel = [[MutipleMeettingViewModel alloc] init];
    viewModel.meettingDelegate = self;

    [self setupLocalVideo];
    
    //为了等待初始化结束  延迟两秒执行布局
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutMemberWindow];
        [viewModel fetchRoomInfoWithRoomId:self.roomId Complete:^(MedLiveRoomMeetting *room) {
            [viewModel joinMeetting:room.channelId];
        }];
    });
}

- (void)setupLocalVideo{
    MutipleView *view = [[MutipleView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [view enableFlexLayout:YES];

    view.uid = [AppCommondCenter sharedCenter].currentUser.uid.integerValue;

    [streamView addSubview:view];
    [memberAry addObject:view];
    [viewModel setupLocalView:view];
}

- (void)viewDidLayoutSubviews{
    [self layoutMemberWindow];
}

- (void)addView:(NSInteger)uid{
    //保证uid唯一
    for (MutipleView *view in memberAry) {
        if (view.uid == uid) {
            return;
            break;
        }
    }
    
    //构建UI
    MutipleView *view = [[MutipleView alloc] init];
    view.uid = uid;
    [view enableFlexLayout:YES];
    [streamView addSubview:view];
    
    //插入视图表
    [memberAry addObject:view];
    //布局
    [self layoutMemberWindow];
    //载入远端流
    [viewModel setupRemoteView:view];
    
    __weak UIView *weakContainor = streamView;
    __weak MutipleView *weakView = view;
    CGFloat newWidth = containor.bounds.size.width;
    CGFloat newHeight = containor.bounds.size.height;
    WeakSelf
    view.screenBlock = ^BOOL{
        static BOOL isFullScreen = NO;
        if (!isFullScreen) {
            [weakView setLayoutAttrStrings:@[
                @"width",[NSString stringWithFormat:@"%f",newWidth],
                @"height",[NSString stringWithFormat:@"%f",newHeight],
                @"margin",@"0",
                @"position",@"absolute"
            ]];
            
            [weakContainor markDirty];
            isFullScreen = YES;
            
        }else{
            [weakSelf layoutMemberWindow];
            isFullScreen = NO;
        }
        return isFullScreen;
    };
}

//布局多人视频流
- (void)layoutMemberWindow{
    if (memberAry.count>1) {
        for (UIView *view in memberAry) {
            //容器宽度-padding
            CGFloat containorWidth = self.view.frame.size.width;
            //再减去间距
            CGFloat widthWithoutSpacing = containorWidth - HoritonSpace *6;
            CGFloat lineWidth = widthWithoutSpacing/3;
            [view setLayoutAttrStrings:@[
                @"width",[NSString stringWithFormat:@"%f",lineWidth],
                @"height",[NSString stringWithFormat:@"%f",lineWidth*1.3],
                @"margin",[NSString stringWithFormat:@"%f",HoritonSpace],
                @"position",@"ralative"
            ]];
        }
    }else{
        CGSize size = containor.frame.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        
        UIView *view = [memberAry firstObject];
        [view setLayoutAttrStrings:@[
            @"width",[NSString stringWithFormat:@"%f",width],
            @"height",[NSString stringWithFormat:@"%f",height],
            @"margin",@"0",
        ]];
    }
    [streamView markDirty];
}

#pragma viewModel Delegate
//进入
- (void)meetingDidJoinMember:(NSInteger)uid{
    [self addView:uid];
    
    memberCountLabel.text = [NSString stringWithFormat:@"人数(%ld)",memberAry.count];
}
//离开
- (void)meetingDidLeaveMember:(NSInteger)uid{
    MutipleView *targetView;
    for (MutipleView *view in memberAry) {
        if (view.uid == uid) {
            targetView = view;
            [view removeFromSuperview];
            break;;
        }
    }
    [memberAry removeObject:targetView];
    [self layoutMemberWindow];
    targetView = nil;
    
    memberCountLabel.text = [NSString stringWithFormat:@"人数(%ld)",memberAry.count];
}
//音量
- (void)meettingMemberSpeaking:(NSInteger)uid{
    [memberAry enumerateObjectsUsingBlock:^(MutipleView *view, NSUInteger idx, BOOL *stop) {
        if (view.uid == uid) {
            view.micView.hidden = NO;
            view.micView.alpha = 1;
            [UIView animateWithDuration:0.2 delay:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
                view.micView.alpha = 0;
            } completion:nil];
            *stop = YES;
        }
    }];
}

- (void)meettingMember:(NSInteger)uid DidCloseCamera:(BOOL)closed{
    [memberAry enumerateObjectsUsingBlock:^(MutipleView * remoteView, NSUInteger idx, BOOL *stop) {
        if (remoteView.uid == uid) {
            [remoteView layoutVideoOffMask:!closed];
            *stop = YES;
        }
    }];
}

#pragma 功能条
//静音
- (void)mute{
    static BOOL isMute = YES;
    if (isMute) {
        micOnImg.hidden = YES;
        micOffImg.hidden = NO;
        micLabel.text = @"启用";
    }else{
        micOnImg.hidden = NO;
        micOffImg.hidden = YES;
        micLabel.text = @"静音";
    }
    [viewModel muteLocalMic:isMute];
    isMute = !isMute;
}
//关摄像头
- (void)startVideo{
    static BOOL cameraOff = YES;
    if (cameraOff) {
        cameraOnImg.hidden = YES;
        cameraOffImg.hidden = NO;
        cameraLabel.text = @"开启视频";
    }else{
        cameraOnImg.hidden = NO;
        cameraOffImg.hidden = YES;
        cameraLabel.text = @"关闭视频";
    }
    [viewModel disableLocalvideo:!cameraOff success:^{
        MutipleView *localVideo = [memberAry firstObject];
        [localVideo layoutVideoOffMask:!cameraOff];
        cameraOff = !cameraOff;
    }];
}
//共享屏幕
- (void)shareScreen{
    
}
//挂断
- (void)getEnd{
    [viewModel stopLive];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchCamera{
    [viewModel switchCamera];
}
- (void)otherFunc{
    toolsView.hidden = !toolsView.hidden;
}

- (void)viewDidDisappear:(BOOL)animated{
    
}

- (void)dealloc
{
}
@end
