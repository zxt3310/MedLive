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

#import "IMManager.h"

@interface SKLMeetController ()<SKLMeetViewDelegate>

@end

@implementation SKLMeetController
{
    NSString *roomTitleText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *createLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [createLiveBtn setBackgroundColor:[UIColor blueColor]];
//    [createLiveBtn setTitle:@"我要直播" forState:UIControlStateNormal];
//    [createLiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [createLiveBtn addTarget:self action:@selector(liveUpAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:createLiveBtn];
//
//    [createLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(120, 50));
//    }];
//
//    UITextField *titleField = [[UITextField alloc] init];
//    titleField.backgroundColor = [UIColor whiteColor];
//    [titleField addTarget:self action:@selector(titleChanged:) forControlEvents:UIControlEventEditingChanged];
//    titleField.placeholder = @"房间主题，默认：ios测试";
//    titleField.layer.borderWidth = 1;
//    titleField.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:titleField];
//
//    [titleField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(createLiveBtn.mas_centerX);
//        make.bottom.equalTo(createLiveBtn.mas_top).with.offset(-30);
//        make.size.mas_equalTo(CGSizeMake(250, 50));
//    }];
    
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


- (void)meetViewActCreateConsultation{
    IMManager *im = [IMManager sharedManager];
    [im loginToAgoraServiceWithId:@"smandll" Token:nil];
}
- (void)meetViewActCreateMeet{
    SKLMeetCreateController *createMeet = [[SKLMeetCreateController alloc] init];
    [self.navigationController pushViewController:createMeet animated:YES];
}
- (void)meetViewActCreateLive{
    SKLLiveCreateController *creatLive = [[SKLLiveCreateController alloc] init];
    [self.navigationController pushViewController:creatLive animated:YES];
}
- (void)meetViewActJoin{
    [FlexSetPreviewVC presentInVC:self];
}

@end
