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
#import "MedLiveRoomConsultation.h"
#import "MedLivePatientController.h"
#import "MedMutipleDocumentViewController.h"
#import <LGAlertView.h>

#define HoritonSpace 5.0
#define VerticalSpace 5.0

@interface MedMultipleMeettingController ()<MedMutipleMeetingDelegate>

@end

@implementation MedMultipleMeettingController
{
    FlexScrollView *containor;
    MutipleMeettingViewModel *viewModel;
    NSMutableArray <MutipleView*> *memberAry; //参会人员视图
    //UIView *streamView;
    
    UIImageView *micOnImg;
    UIImageView *micOffImg;
    UIImageView *cameraOnImg;
    UIImageView *cameraOffImg;
    
    UILabel *micLabel;
    UILabel *cameraLabel;
    UIView *toolsView;
    UIView *toolBar;
    
    UILabel *memberCountLabel;//频道人员计数
    //参会人员
    FlexTouchView *memberBtn;
    FlexModalView *memberModel;
    UITableView *memberTable;
    
    //会诊时展现
    FlexTouchView *patientBtn;
    FlexModalView *patientModel;
    UITableView *patientTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view enableFlexLayout:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPatientInfoVC:) name:PatientInfoPushNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMemberTable) name:MemberDidChangeNotification object:nil];
    
    memberAry = [NSMutableArray array];
    
    viewModel = [[MutipleMeettingViewModel alloc] init];
    viewModel.meettingDelegate = self;

    [self setupLocalVideo];
    //加载人员列表
    [self setupMemberModel];
    
    //为了等待初始化结束  延迟两秒执行布局
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutMemberWindow];
        WeakSelf
        [viewModel fetchRoomInfoWithRoomId:self.roomId Complete:^(MedLiveRoomMeetting *room) {
            [viewModel joinMeetting:room.channelId];
            if([room isMemberOfClass:[MedLiveRoomConsultation class]]){
                [weakSelf setupPatientsModel];
            }
        }];
        [toolsView setLayoutAttrStrings:@[@"bottom",[NSString stringWithFormat:@"%f",(toolBar.frame.size.height + 5)]]];
    });
}

- (void)setupLocalVideo{
    MutipleView *view = [[MutipleView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [view enableFlexLayout:YES];

    view.uid = [AppCommondCenter sharedCenter].currentUser.uid.integerValue;

    [containor addSubview:view];
    [memberAry addObject:view];
    [viewModel setupLocalView:view];
}

- (void)setupMemberModel{
    memberTable.uniTag = @"member";
    memberTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    memberTable.delegate = viewModel;
    memberTable.dataSource = viewModel;
    memberTable.tableFooterView = [UIView new];
    memberTable.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupPatientsModel{
    patientTable.uniTag = @"patient";
    patientTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    patientTable.delegate = viewModel;
    patientTable.dataSource = viewModel;
    patientTable.tableFooterView = [UIView new];
    patientTable.rowHeight = UITableViewAutomaticDimension;
    patientBtn.hidden = NO;
}

- (void)reloadMemberTable{
    [memberTable reloadData];
}

- (void)showMembers{
    [memberModel showModalInView:self.view Anim:YES];
}
#pragma mark 会诊功能
- (void)showPatient{
    [patientModel showModalInView:self.view Anim:YES];
}

- (void)showPatientInfoVC:(NSNotification *)notify{
    Patient *patient = notify.object;
    MedLivePatientController *patientVC = [[MedLivePatientController alloc] init];
    patientVC.patient = patient;
    
    [patientModel hideModal:YES];
    
    [self.navigationController pushViewController:patientVC animated:YES];
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
    [containor addSubview:view];
    
    //插入视图表
    [memberAry addObject:view];
    //布局
    [self layoutMemberWindow];
    //载入远端流
    [viewModel setupRemoteView:view];
    
    __weak FlexScrollView *weakContainor = containor;
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
            
            [weakContainor.contentView markDirty];
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
                @"aspectRatio",[NSString stringWithFormat:@"0.8"],
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
            @"position",@"absolute",
            @"margin",@"0",
        ]];
    }
    [containor.contentView markDirty];
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

- (void)meetMemberBecomeActive:(NSInteger)uid{
    [memberAry enumerateObjectsUsingBlock:^(MutipleView *remoteView, NSUInteger idx, BOOL *stop) {
        
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
    LGAlertView *alert = [LGAlertView alertViewWithTitle:@"退出会议"
                                                  message:@"创建者退出,会议即结束"
                                                   style:LGAlertViewStyleAlert
                                            buttonTitles:@[@"确定"]
                                       cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil];
    alert.messageTextColor = [UIColor redColor];
    
    __weak MutipleMeettingViewModel *weakModel = viewModel;
    WeakSelf
    alert.actionHandler= ^(LGAlertView *alertView, NSUInteger index, NSString *title){
        [weakModel stopLive];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [alert showAnimated];
}

- (void)switchCamera{
    [viewModel switchCamera];
}

- (void)showDocument{
    MedMutipleDocumentViewController *docVC = [[MedMutipleDocumentViewController alloc] init];
    docVC.documentUrls = [viewModel getDocs];
    [self.navigationController pushViewController:docVC animated:YES];
}
- (void)otherFunc{
    toolsView.hidden = !toolsView.hidden;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
