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
    UIView *loginEntry;
    UIView *infoView;
    UIView *vipView;
}
@end

@implementation SKLUserCenterController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AppCommondCenter sharedCenter] addObserver:self forKeyPath:@"hasLogin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([AppCommondCenter sharedCenter].hasLogin){
        loginEntry.hidden = YES;
        infoView.hidden = NO;
        mobileLabel.text = [AppCommondCenter sharedCenter].currentUser.mobile;
    }
    
}
- (void)viewDidLayoutSubviews{
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat statusBarHeight = self.view.safeAreaInsets.top;
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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //登录状态样式切换
    if (!context) {
        if ([[change valueForKey:@"new"] boolValue] == true) {
            loginEntry.hidden = YES;
            infoView.hidden = NO;
            mobileLabel.text = [object valueForKeyPath:@"currentUser.mobile"];
        }else{
            loginEntry.hidden = NO;
            infoView.hidden = YES;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
