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
#import "MedLiveWebContoller.h"

@interface MedLiveLoginController ()<LoginViewDelegate>

@end

@implementation MedLiveLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgVIew = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgVIew.contentMode = UIViewContentModeScaleAspectFill;
    bgVIew.image = [UIImage imageNamed:@"loginBGI"];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(.5, 0);
    gradient.endPoint = CGPointMake(.5, .7);
    UIColor *startColor = [UIColor ColorWithRGB:33 Green:89 Blue:187 Alpha:0.7];
    UIColor *endColor = [UIColor ColorWithRGB:33 Green:89 Blue:187 Alpha:1];
    gradient.colors = @[(id)startColor.CGColor,(id)endColor.CGColor];
    gradient.frame = self.view.bounds;
    [bgVIew.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:bgVIew];
    
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
        NSString *uid = [[userInfo valueForKey:@"user_id"] stringValue];
        AppCommondCenter *center = [AppCommondCenter sharedCenter];
        [center loginWithUid:uid];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)loginView:(MedLiveLoginView *)view SendMobileMsg:(NSString *)mobile Complete:(void (^)(NSString *code , BOOL success))completeBlock{
    MedLiveSendMsgRequest *request = [[MedLiveSendMsgRequest alloc] initWithMobile:mobile];
    [request sendMessageSuccess:^(NSString * _Nonnull code) {
        completeBlock(code,YES);
    } fail:^(NSString * errMsg) {
        completeBlock(errMsg,NO);
    }];
    
}

- (void)loginViewShouldPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginViewShouldPushWeb:(NSString *)url{
    MedLiveWebContoller *web = [[MedLiveWebContoller alloc] init];
    web.urlStr = url;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
 
- (void)dealloc
{
    NSLog(@"login controller release success");
}
@end
