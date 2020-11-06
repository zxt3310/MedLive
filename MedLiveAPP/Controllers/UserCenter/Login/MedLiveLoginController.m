//
//  MedLiveLoginController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/26.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveLoginController.h"
#import "MedLiveLoginView.h"
#import "MedLiveNetManager.h"
#import "MedLiveSendMsgRequest.h"
#import "MedLiveLoginRequest.h"

@interface MedLiveLoginController ()<LoginViewDelegate>

@end

@implementation MedLiveLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MedLiveLoginView *loginUI = [[MedLiveLoginView alloc] init];
    loginUI.loginDelegate = self;
    [self.view addSubview:loginUI];
    
    [loginUI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (void)loginStart{
    MedLiveLoginRequest *req = [[MedLiveLoginRequest alloc] init];
    [req requestLogin:^(MedLiveLoginRequest * _Nonnull request) {
        
    }];
}

- (void)loginView:(MedLiveLoginView *)view StartLoginWithMobile:(NSString *)mobile Code:(NSString *)code{
    MedLiveLoginRequest *request = [[MedLiveLoginRequest alloc] initWithMobile:mobile Code:code];
    [request requestLogin:^(id userInfo) {
        AppCommondCenter *center = [AppCommondCenter sharedCenter];
        center.currentUser.mobile = mobile;
        center.currentUser.uid = [[userInfo valueForKey:@"uid"] integerValue];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)loginView:(MedLiveLoginView *)view SendMobileMsg:(NSString *)mobile Complete:(void (^)(NSString *code , BOOL success))completeBlock{
    completeBlock(@"1234",YES);
    MedLiveSendMsgRequest *request = [[MedLiveSendMsgRequest alloc] initWithMobile:mobile];
    [request sendMessageSuccess:^(NSString * _Nonnull code) {
        completeBlock(code,YES);
    } fail:^(NSString * errMsg) {
        completeBlock(errMsg,NO);
    }];
    
}
 
- (void)dealloc
{
    NSLog(@"login controller release success");
}
@end
