//
//  MedLiveBaseFlexViewController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/17.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveBaseFlexViewController.h"
#import "TYSPNaviBar.h"

@interface MedLiveBaseFlexViewController ()

@end

@implementation MedLiveBaseFlexViewController
{
    TYSPNaviBar *navigationBar;
}
@synthesize title = _title;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigation];
    
}

- (void)setupNavigation{
    navigationBar = [[TYSPNaviBar alloc] initWithFlex:@"TYSPNaviBar" Frame:CGRectMake(0, 0, kScreenWidth, kNavBarAndStatusBarHeight) Owner:nil];
    [self.view addSubview:navigationBar];
    
    WeakSelf
    navigationBar.shouldPop = ^{
        [weakSelf popViewController];
    };
    navigationBar.rightCall = ^{
        [weakSelf rightItemCall];
    };
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets safeArea = self.view.safeAreaInsets;
    [navigationBar setLayoutAttrStrings:@[
        @"height",[NSString stringWithFormat:@"%f",safeArea.top + 44],
        @"width",[NSString stringWithFormat:@"%f",self.view.bounds.size.width]
    ]];
    [navigationBar markDirty];
}

- (UIEdgeInsets)getSafeArea:(BOOL)portrait{
    UIEdgeInsets inset = UIEdgeInsetsMake(kNavBarAndStatusBarHeight, 0, kBottomSafeHeight, 0);
    return inset;
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemCall{
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [navigationBar setTitle:title];
}

@end
