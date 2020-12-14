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
    UITextField *codeFiled;
    UIButton *popBtn;
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
    
    UIView *phoneLeft = [[UIView alloc] init];
    UIView *codeLeft = [[UIView alloc] init];
    UIImageView *phoneImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    [phoneLeft addSubview:phoneImg];
    UIImageView *codeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code"]];
    [codeLeft addSubview:codeImg];
    
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.leftView = phoneLeft;
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
    
    codeFiled = [[UITextField alloc] init];
    codeFiled.leftView = codeLeft;
    codeFiled.leftViewMode = UITextFieldViewModeAlways;
    codeFiled.layer.cornerRadius = 10;
    codeFiled.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    codeFiled.textColor = [UIColor whiteColor];
    codeFiled.uniTag = @"code";
    attrString = [[NSAttributedString alloc] initWithString:@"验证码"
                                                 attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                              NSFontAttributeName:codeFiled.font}];
    [codeFiled addTarget:self action:@selector(textFieldDidEditingChange:) forControlEvents:UIControlEventEditingChanged];
    [codeFiled setAttributedPlaceholder:attrString];
    [self addSubview:codeFiled];
    
    popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [popBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:popBtn];
    
    sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCodeBtn.layer.cornerRadius = 10;
    [sendCodeBtn setBackgroundColor:[UIColor ColorWithRGB:101 Green:157 Blue:248 Alpha:1]];
    [sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendCodeBtn addTarget:self action:@selector(messageSend:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendCodeBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 10;
    [loginBtn setBackgroundColor:[UIColor ColorWithRGB:101 Green:157 Blue:248 Alpha:1]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(startLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(30);
        make.top.equalTo(self.mas_top).with.offset(150);
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
    
    UIEdgeInsets imgInset = UIEdgeInsetsMake(0, 8, 0, 8);
    [phoneLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 20));
    }];
    [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(phoneLeft).insets(imgInset);
    }];
    [codeLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 20));
    }];
    [codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(codeLeft).insets(imgInset);
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
        [MedLiveAppUtilies showErrorTip:@"请输入验证码"];
        return;
    }
    if(self.loginDelegate){
        [self.loginDelegate loginView:self StartLoginWithMobile:mobile Code:code];
    }
}

- (void)messageSend:(UIButton *)sender{
    if (![MedLiveAppUtilies checkTelNumber:mobile]) {
        [MedLiveAppUtilies showErrorTip:@"请输入正确的手机号"];
        return;
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
//#ifdef DEBUG
                self->code = messageCode;
                codeFiled.text = messageCode;
//#endif
            }
        }];
    }
}

- (void)safeAreaInsetsDidChange{
    [super safeAreaInsetsDidChange];
    UIEdgeInsets insets = self.safeAreaInsets;
    
    [popBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(insets.top + 10);
        make.left.equalTo(self).offset(20);
    }];
}

- (void)popBack{
    if (self.loginDelegate) {
        [self.loginDelegate loginViewShouldPop];
    }
}

- (void)dealloc{
    NSLog(@"登录页正常释放");
}

@end
