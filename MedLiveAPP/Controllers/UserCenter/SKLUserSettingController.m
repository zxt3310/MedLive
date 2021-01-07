//
//  SKLUserSettingController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/12/9.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLUserSettingController.h"
#import "SKLUserInfoController.h"
#import <LGAlertView.h>

@interface SKLUserSettingController ()

@end

@implementation SKLUserSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)gotoInfo{
    SKLUserInfoController *control = [[SKLUserInfoController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)logout{
    LGAlertView *alert = [LGAlertView alertViewWithTitle:@"注销"
                                                 message:nil
                                                   style:LGAlertViewStyleAlert
                                            buttonTitles:@[@"确定"]
                                       cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil];
    
    alert.actionHandler = ^(LGAlertView *alertView, NSUInteger index, NSString *title) {
        [[AppCommondCenter sharedCenter] logout];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [alert showAnimated];
}

- (void)dealloc
{
    
}

@end
