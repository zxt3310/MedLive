//
//  SKLTeamController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLTeamController.h"
#import "MedLiveWebContoller.h"
#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <MJRefresh.h>

@interface SKLTeamController ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>
@property (strong,readonly) WKWebView *mainWebView;

@end

@implementation SKLTeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *uc = [[WKUserContentController alloc] init];
    config.userContentController = uc;
    [uc addScriptMessageHandler:self name:@"channelInfo"];
    _mainWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    _mainWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _mainWebView.UIDelegate = self;
    _mainWebView.navigationDelegate = self;
    [self.view addSubview:_mainWebView];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/expert_list"]]];
    
    _mainWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/expert_list"]]];
        [self.mainWebView.scrollView.mj_header endRefreshing];
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSString *name = message.name;
    if([name isEqualToString:@"channelInfo"]){
        NSDictionary *obj = message.body;
        NSLog(@"%@",obj);
        if(obj[@"room_id"]){
            ViewController *liveCtr = [[ViewController alloc] init];
            liveCtr.roomId = obj[@"room_id"];
            liveCtr.title = obj[@"name"];
            liveCtr.channelId = obj[@"channel_id"];
            [self.navigationController pushViewController:liveCtr animated:YES];
        }
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"http://dev.saikang.ranknowcn.com/h5/expert_list"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        MedLiveWebContoller *webVC = [[MedLiveWebContoller alloc] init];
        webVC.roomType = @"boardcastRole";
        webVC.urlStr = navigationAction.request.URL.absoluteString;
        [self.navigationController pushViewController:webVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            completionHandler();
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
}



- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    [_mainWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(insets);
    }];
}
@end
