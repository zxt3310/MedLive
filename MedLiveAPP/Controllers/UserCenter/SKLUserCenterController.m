//
//  SKLUserCenterController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLUserCenterController.h"
#import "MedLiveLoginController.h"
#import "MedLiveWebContoller.h"
#import "SKLUserSettingController.h"
#import <YYWebImage.h>

char *const LOGSTATE_OBSERVER = "login_state_has_changed";
char *const USERINFO_OBSERVER = "user_info_has_changed";

@interface SKLUserCenterController ()
{
    UIView *topView;
    UILabel *mobileLabel;
    UIView *loginEntry;
    UIView *infoView;
    UIView *vipView;
    UIImageView *headImgView;
    UILabel *stateLabel;
    UILabel *uidLabel;
}
@end

@implementation SKLUserCenterController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AppCommondCenter sharedCenter] addObserver:self
                                          forKeyPath:@"hasLogin"
                                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                             context:LOGSTATE_OBSERVER];
        
        [[AppCommondCenter sharedCenter] addObserver:self
                                          forKeyPath:@"currentUser"
                                             options:NSKeyValueObservingOptionNew
                                             context:USERINFO_OBSERVER];
    }
    return self;
}

- (void)dealloc
{
    [[AppCommondCenter sharedCenter] removeObserver:self
                                       forKeyPath:@"hasLogin"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([AppCommondCenter sharedCenter].hasLogin){
        loginEntry.hidden = YES;
        infoView.hidden = NO;
        MedLiveUserModel *user = [AppCommondCenter sharedCenter].currentUser;
        [AppCommondCenter sharedCenter].currentUser = user;
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

- (void)myLive{
    if (![MedLiveAppUtilies needLogin]) {
        NSString *url = [NSString stringWithFormat:@"%@/h5/boardcast_list?user_id=%@",Domain,[AppCommondCenter sharedCenter].currentUser.uid];
        [self pushWebVC:url Type:@"boardcast" Title:@"我的直播"];
    }
}

- (void)myMeetting{
    if (![MedLiveAppUtilies needLogin]) {
        NSString *url = [NSString stringWithFormat:@"%@/h5/meeting_list?user_id=%@",Domain,[AppCommondCenter sharedCenter].currentUser.uid];
        [self pushWebVC:url Type:@"meeting" Title:@"我的会议"];
    }
}

- (void)myConsultation{
    if (![MedLiveAppUtilies needLogin]) {
        NSString *url = [NSString stringWithFormat:@"%@/h5/consultation_list?user_id=%@",Domain,[AppCommondCenter sharedCenter].currentUser.uid];
        [self pushWebVC:url Type:@"consultation" Title:@"我的会诊"];
    }
}

- (void)goToSetting{
    if (![MedLiveAppUtilies needLogin]) {
        SKLUserSettingController *settingVC = [[SKLUserSettingController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)goToFavor{
    if (![MedLiveAppUtilies needLogin]) {
        NSString *url = [NSString stringWithFormat:@"%@/h5/favorite_list?user_id=%@",Domain,[AppCommondCenter sharedCenter].currentUser.uid];
        [self pushWebVC:url Type:@"watchLive" Title:@"我的收藏"];
    }
}

- (void)doctorVarify{
    if(![MedLiveAppUtilies needLogin] &&
       ([AppCommondCenter sharedCenter].currentUser.doctorAuditState == DocAuditStateNotyet||
       [AppCommondCenter sharedCenter].currentUser.doctorAuditState == DocAuditStateDiend)){
        NSString *url = [NSString stringWithFormat:@"%@/h5/doctor_update_info?user_id=%@",Domain,[AppCommondCenter sharedCenter].currentUser.uid];
        [self pushWebVC:url Type:nil Title:@"医生认证"];
    }
}

- (void)pushWebVC:(NSString *)url Type:(NSString *)type Title:(NSString *)title{
    MedLiveWebContoller *webVC = [[MedLiveWebContoller alloc] init];
    webVC.roomType = type;
    webVC.urlStr = url;
    webVC.title = title;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //登录状态样式切换
    if (context == LOGSTATE_OBSERVER) {
        if ([[change valueForKey:@"new"] boolValue] == true) {
            loginEntry.hidden = YES;
            infoView.hidden = NO;
            mobileLabel.text = [object valueForKeyPath:@"currentUser.mobile"];
            uidLabel.text = [object valueForKeyPath:@"currentUser.uid"];
        }else{
            loginEntry.hidden = NO;
            infoView.hidden = YES;
            headImgView.image = [UIImage imageNamed:@"header"];
        }
    }else if(context == USERINFO_OBSERVER){
        MedLiveUserModel *newUser = (MedLiveUserModel *)[change valueForKey:@"new"];
        mobileLabel.text = KIsBlankString(newUser.userName)?newUser.mobile:newUser.userName;
        uidLabel.text = [NSString stringWithFormat:@"ID：%@",newUser.uid];
        if (!KIsBlankString(newUser.headerImgUrl)) {
            headImgView.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Cdn_domain,newUser.headerImgUrl]];
        }
        
        switch (newUser.doctorAuditState) {
            case DocAuditStateIng:
                [stateLabel setViewAttrStrings:@[@"text",@"审核中",@"color",@"#333333"]];
                break;
            case DocAuditStateDone:
                [stateLabel setViewAttrStrings:@[@"text",@"已认证",@"color",@"green"]];
                break;
            case DocAuditStateDiend:
                [stateLabel setViewAttrStrings:@[@"text",@"已拒绝",@"color",@"red"]];
                break;
            default:
                [stateLabel setViewAttrStrings:@[@"text",@"",@"color",@"#333333"]];
                break;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
