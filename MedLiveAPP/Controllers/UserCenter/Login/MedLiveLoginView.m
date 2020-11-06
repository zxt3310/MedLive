//
//  MedLiveLoginView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/26.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveLoginView.h"

@interface MedLiveLoginView()

@end

@implementation MedLiveLoginView
{
    NSString *mobile;
    NSString *code;
    UIButton *sendCodeBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *titleView = [[UIView alloc] init];
    self.backgroundColor = [UIColor ColorWithRGB:53 Green:87 Blue:158 Alpha:1];
    UILabel *title1 = [[UILabel alloc] init];
    UILabel *title2 = [[UILabel alloc] init];
    title1.text = @"赛康";
    title1.textColor = [UIColor whiteColor];
    title1.font = [UIFont systemFontOfSize:20];
    
    title2.text = @"专注医学会诊直播，让交流变得更简单";
    title2.textColor = [UIColor whiteColor];
    [titleView addSubview:title1];
    [titleView addSubview:title2];
    [self addSubview:titleView];
    
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    phoneField.layer.cornerRadius = 5;
    phoneField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    phoneField.textColor = [UIColor whiteColor];
    phoneField.uniTag = @"mobile";
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"手机号码"
                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                  NSFontAttributeName:phoneField.font}];
    [phoneField addTarget:self action:@selector(textFieldDidEditingChange:) forControlEvents:UIControlEventEditingChanged];
    [phoneField setAttributedPlaceholder:attrString];
    [self addSubview:phoneField];
    
    UITextField *codeFiled = [[UITextField alloc] init];
    codeFiled.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code"]];
    codeFiled.leftViewMode = UITextFieldViewModeAlways;
    codeFiled.layer.cornerRadius = 5;
    codeFiled.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    codeFiled.textColor = [UIColor whiteColor];
    codeFiled.uniTag = @"code";
    attrString = [[NSAttributedString alloc] initWithString:@"验证码"
                                                 attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                              NSFontAttributeName:codeFiled.font}];
    [codeFiled addTarget:self action:@selector(textFieldDidEditingChange:) forControlEvents:UIControlEventEditingChanged];
    [codeFiled setAttributedPlaceholder:attrString];
    [self addSubview:codeFiled];
    
    sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCodeBtn.layer.cornerRadius = 5;
    [sendCodeBtn setBackgroundColor:[UIColor ColorWithRGB:101 Green:157 Blue:248 Alpha:1]];
    [sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendCodeBtn addTarget:self action:@selector(messageSend:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendCodeBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 5;
    [loginBtn setBackgroundColor:[UIColor ColorWithRGB:101 Green:157 Blue:248 Alpha:1]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(startLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(30);
        make.top.equalTo(self.mas_top).with.offset(120);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.height.mas_equalTo(60);
    }];
    
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.top.equalTo(titleView.mas_top);
    }];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).with.offset(120);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.height.mas_equalTo(50);
    }];
    [codeFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneField.mas_bottom).with.offset(20);
        make.left.equalTo(phoneField);
        make.right.equalTo(phoneField);
        make.height.mas_equalTo(50);
    }];
    
    [sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneField.mas_right);
        make.top.equalTo(phoneField.mas_top);
        make.bottom.equalTo(phoneField.mas_bottom);
        make.width.mas_equalTo(120);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeFiled.mas_bottom).with.offset(40);
        make.left.mas_equalTo(codeFiled.mas_left);
        make.right.mas_equalTo(codeFiled.mas_right);
        make.height.equalTo(codeFiled.mas_height);
    }];
}

- (void)textFieldDidEditingChange:(UITextField *)textField{
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([textField.uniTag isEqualToString:@"mobile"]){
        mobile = str;
    }else if ([textField.uniTag isEqualToString:@"code"]){
        code = str;
    }
}

- (void)startLogin{
    if (KIsBlankString(mobile) && KIsBlankString(code)) {
        NSLog(@"手机号 验证码没填");
        return;
    }
    if(self.loginDelegate){
        [self.loginDelegate loginView:self StartLoginWithMobile:mobile Code:code];
    }
}

- (void)messageSend:(UIButton *)sender{
    if (![MedLiveAppUtilies checkTelNumber:mobile]) {
        return;;
    }
    sender.enabled = NO;
    
    if (self.loginDelegate) {
        [self.loginDelegate loginView:self SendMobileMsg:mobile Complete:^(NSString * messageCode,BOOL success) {
            if (!success) {
                sender.enabled = YES;
            }else{
                __block int second = 20;
                [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    NSString *btnStr = [NSString stringWithFormat:@"重新发送(%d)",second];
                    [sender setTitle:btnStr forState:UIControlStateNormal];
                    second--;
                    if (second <0) {
                        [timer invalidate];
                        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                        sender.enabled = YES;
                    }
                }];
#ifdef DEBUG
                self->code = messageCode;
#endif
            }
        }];
    }
}

- (void)dealloc{
    NSLog(@"登录页正常释放");
}

@end
