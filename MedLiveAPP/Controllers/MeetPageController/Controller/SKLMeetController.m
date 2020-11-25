//
//  SKLMeetController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMeetController.h"
#import "ViewController.h"
#import "MedLiveController.h"
#import "SKLMeetView.h"
#import "SKLLiveCreateController.h"
#import "SKLMeetCreateController.h"
#import "MedMultipleMeettingController.h"

@interface SKLMeetController ()<SKLMeetViewDelegate>

@end

@implementation SKLMeetController
{
    NSString *roomTitleText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKLMeetView *view = [[SKLMeetView alloc] init];
    view.meetViewDelegate = self;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (void)titleChanged:(UITextField *)field{
    roomTitleText = field.text;
}

- (void)liveUpAction{
    MedLiveController *ctr = [[MedLiveController alloc] init];
    ctr.titleName = roomTitleText ?: @"ios测试";
    [self.navigationController pushViewController:ctr animated:YES];
}

//会诊
- (void)meetViewActCreateConsultation{
    
    [FlexSetPreviewVC presentInVC:self];
}
//会议
- (void)meetViewActCreateMeet{
    if(![MedLiveAppUtilies needLogin]){
        SKLMeetCreateController *createMeet = [[SKLMeetCreateController alloc] init];
        [self.navigationController pushViewController:createMeet animated:YES];
    }
}
//直播
- (void)meetViewActCreateLive{
    if (![MedLiveAppUtilies needLogin]) {
        SKLLiveCreateController *creatLive = [[SKLLiveCreateController alloc] init];
        [self.navigationController pushViewController:creatLive animated:YES];
    }
}
- (void)meetViewActJoin{
    if (![MedLiveAppUtilies needLogin]) {
       
    }
}

@end
