//
//  SKLJoinMeetController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/26.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLJoinMeetController.h"
#import "SKLMeetJoinMeetController.h"

@interface SKLJoinMeetController ()

@end

@implementation SKLJoinMeetController
{
    UITextField *roomIdField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入会议";
    
    
}

- (void)joinMeetJoin{
    if (KIsBlankString(roomIdField.text)) {
        [MedLiveAppUtilies showErrorTip:@"请输入会议号"];
        return;
    }
    
    NSString *roomId = roomIdField.text;
    SKLMeetJoinMeetController *joimMeetVC = [[SKLMeetJoinMeetController alloc] init];
    joimMeetVC.roomId = roomId;
    [self.navigationController pushViewController:joimMeetVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
