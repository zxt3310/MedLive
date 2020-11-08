//
//  SKLUserCenterController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLUserCenterController.h"
#import "MedLiveLoginController.h"

@interface SKLUserCenterController ()
{
    UIView *topView;
    UILabel *mobileLabel;
    UIView *vipView;
}
@end

@implementation SKLUserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)viewDidLayoutSubviews{
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat statusBarHeight = self.view.safeAreaInsets.top;
        //[topView enableFlexLayout:YES];
        [topView setLayoutAttr:@"height" Value:[NSString stringWithFormat:@"%f",statusBarHeight]];
        [topView markDirty];
    });
}

- (void)login{
    MedLiveLoginController *logVC = [[MedLiveLoginController alloc] init];
    [self.navigationController pushViewController:logVC animated:YES];
}

- (UIEdgeInsets)getSafeArea:(BOOL)portrait{
    UIEdgeInsets insets = self.view.safeAreaInsets;
    insets.top = 0;
    return insets;
}
@end
