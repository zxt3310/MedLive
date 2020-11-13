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
#import "NSArray+Sudoku.h"

#define HoritonSpace 5.0
#define VerticalSpace 5.0

@interface MedMultipleMeettingController ()<MedMutipleMeetingDelegate>

@end

@implementation MedMultipleMeettingController
{
    UIView *containor;
    MutipleMeettingViewModel *viewModel;
    NSMutableArray <MutipleView*> *memberAry; //参会人员视图
    UIView *streamView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    memberAry = [NSMutableArray array];
    
    viewModel = [[MutipleMeettingViewModel alloc] init];
    viewModel.meettingDelegate = self;

    [self setupLocalVideo];
    [viewModel joinMeetting:@"" Token:@""];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self layoutMemberWindow];
    });
    
}

- (void)setupLocalVideo{
    MutipleView *view = [[MutipleView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [view enableFlexLayout:YES];
#ifdef TESTCODE
    view.uid = 0;
#else
    view.uid = [AppCommondCenter sharedCenter].currentUser.uid.integerValue;
#endif
    [streamView addSubview:view];
    [memberAry addObject:view];
    [viewModel setupLocalView:view];
}

- (void)viewDidLayoutSubviews{
    [self layoutMemberWindow];
}

- (void)addView:(NSInteger)uid{
    //构建UI
    MutipleView *view = [[MutipleView alloc] init];
    view.uid = uid;
    [view enableFlexLayout:YES];
    view.layer.borderWidth = 1;
    [streamView addSubview:view];
    
    //插入视图表
    [memberAry addObject:view];
    //布局
    [self layoutMemberWindow];
    //载入远端流
    [viewModel setupRemoteView:view];
    
    __weak UIView *weakView = streamView;
    view.screenBlock = ^BOOL{
        if ([[weakView.subviews firstObject] isEqual:view]) {
            
        }
    };
}

//布局多人视频流
- (void)layoutMemberWindow{
    if (memberAry.count>1) {
        for (UIView *view in memberAry) {
            //容器宽度-padding
            CGFloat containorWidth = self.view.frame.size.width - 10;
            //再减去间距
            CGFloat widthWithoutSpacing = containorWidth - HoritonSpace *6;
            CGFloat lineWidth = widthWithoutSpacing/3;
            [view setLayoutAttrStrings:@[
                @"width",[NSString stringWithFormat:@"%f",lineWidth],
                @"height",[NSString stringWithFormat:@"%f",lineWidth*1.3],
                @"margin",[NSString stringWithFormat:@"%f",HoritonSpace],
            ]];
        }
    }else{
        CGSize size = containor.frame.size;
        CGFloat width = size.width - 10;
        CGFloat height = size.height - 10;
        
        UIView *view = [memberAry firstObject];
        [view setLayoutAttrStrings:@[
            @"width",[NSString stringWithFormat:@"%f",width],
            @"height",[NSString stringWithFormat:@"%f",height]
        ]];
    }
    [streamView markDirty];
}

- (void)meetingDidJoinMember:(NSInteger)uid{
    [self addView:uid];
}

- (void)meetingDidLeaveMember:(NSInteger)uid{
    MutipleView *targetView;
    for (MutipleView *view in memberAry) {
        if (view.uid == uid) {
            targetView = view;
            [view removeFromSuperview];
            break;;
        }
    }
    [streamView markDirty];
    [memberAry removeObject:targetView];
    targetView = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [viewModel stopLive];
}

- (void)dealloc
{
}
@end
