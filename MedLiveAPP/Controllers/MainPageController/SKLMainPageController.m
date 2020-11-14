//
//  SKLMainPageController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMainPageController.h"
#import <WebKit/WebKit.h>
#import "ViewController.h"
#import <MJRefresh.h>

@interface SKLMainPageController ()<WKScriptMessageHandler>
@property (strong,readonly) WKWebView *mainWebView;
@end

@implementation SKLMainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *uc = [[WKUserContentController alloc] init];
    config.userContentController = uc;
    [uc addScriptMessageHandler:self name:@"channelInfo"];
    _mainWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:_mainWebView];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/home"]]];
    
    _mainWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/home"]]];
        [self.mainWebView.scrollView.mj_header endRefreshing];
    }];
}

- (void)viewWillLayoutSubviews{
    [_mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSString *name = message.name;
    if([name isEqualToString:@"channelInfo"]){
        NSDictionary *obj = message.body;
        NSLog(@"%@",obj);
        ViewController *liveCtr = [[ViewController alloc] init];
        liveCtr.roomId = obj[@"room"];
        liveCtr.title = obj[@"name"];
        liveCtr.channelId = obj[@"channel_id"];
        [self.navigationController pushViewController:liveCtr animated:YES];
    }
    
}

@end
