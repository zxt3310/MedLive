//
//  SKLTeamController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLTeamController.h"
#import <WebKit/WebKit.h>
#import <MJRefresh.h>

@interface SKLTeamController ()<WKScriptMessageHandler>
@property (strong,readonly) WKWebView *mainWebView;

@end

@implementation SKLTeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *uc = [[WKUserContentController alloc] init];
    config.userContentController = uc;
    //[uc addScriptMessageHandler:self name:@"channelInfo"];
    _mainWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:_mainWebView];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/expert_list"]]];
    
    _mainWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/expert_list"]]];
        [self.mainWebView.scrollView.mj_header endRefreshing];
    }];
}

- (void)viewWillLayoutSubviews{
    [_mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{

}


@end
