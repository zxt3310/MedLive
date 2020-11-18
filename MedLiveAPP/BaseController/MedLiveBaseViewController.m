//
//  MedLiveBaseViewController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/17.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveBaseViewController.h"

@interface MedLiveBaseViewController ()
@property UIView *navigationBar;
@end

@implementation MedLiveBaseViewController
{
    UILabel *titleLabel;
}
@synthesize title = _title;
@synthesize navigationColor = _navigationColor;
@synthesize navigationTextColor = _navigationTextColor;
@synthesize titleFont = _titleFont;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
}

- (void)setupNavigationBar{
    self.navigationBar = [[UIView alloc] init];
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationBar.clipsToBounds = YES;
    [self.view addSubview:self.navigationBar];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:3];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:backBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationBar.mas_centerX);
        make.bottom.equalTo(self.navigationBar.mas_bottom).offset(-5);
        make.height.mas_equalTo(30);
    }];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navigationBar.mas_bottom).offset(-5);
        make.left.equalTo(self.navigationBar.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _layoutView = [[UIView alloc] init];
    [self.view addSubview:_layoutView];
    [_layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    
}


- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets safeArea = self.view.safeAreaInsets;
    [self.navigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(safeArea.top + 44);
    }];
    
    [self.layoutView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-safeArea.bottom);
    }];
}

- (void) backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    [self.view layoutIfNeeded];
    titleLabel.text = title;
}

- (void)setNavigationColor:(UIColor *)navigationColor{
    _navigationColor = navigationColor;
    self.navigationBar.backgroundColor = navigationColor;
}

- (void)setNavigationTextColor:(UIColor *)navigationTextColor{
    _navigationTextColor = navigationTextColor;
    titleLabel.textColor = navigationTextColor;
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    titleLabel.font = titleFont;
}
@end

