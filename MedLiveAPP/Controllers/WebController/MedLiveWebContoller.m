//
//  MedLiveWebContoller.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/16.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveWebContoller.h"
#import "ViewController.h"
#import "MedMultipleMeettingController.h"
#import "MedLiveController.h"
#import "SKLMeetJoinMeetController.h"
#import <WebKit/WebKit.h>

@interface MedLiveWebContoller ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>

@end

@implementation MedLiveWebContoller
{
    WKWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preference = [[WKPreferences alloc] init];
    preference.javaScriptEnabled = YES;
    config.preferences = preference;
    WKUserContentController *uc = [[WKUserContentController alloc] init];
    config.userContentController = uc;
    
    webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.layoutView);
    }];
    
    if (self.urlStr) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"channelInfo"];
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"doctorVerify"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"channelInfo"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"doctorVerify"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    WeakSelf
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
        if (!error) {
            weakSelf.title = title;
        }
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString *name = message.name;
    if([name isEqualToString:@"channelInfo"]){
        NSDictionary *obj = message.body;
        if (obj[@"room_id"]) {
            NSLog(@"%@",obj);
            
            if ([self.roomType isEqualToString:@"boardcast"]) {
                MedLiveController *liveCtr = [[MedLiveController alloc] init];
                liveCtr.roomId = obj[@"room_id"];
                [self.navigationController pushViewController:liveCtr animated:YES];
            }else if ([self.roomType isEqualToString: @"meeting"] || [self.roomType isEqualToString: @"consultation"])
            {
                SKLMeetJoinMeetController *joinMeetVC = [[SKLMeetJoinMeetController alloc] init];
                joinMeetVC.roomId = obj[@"room_id"];
                [self.navigationController pushViewController:joinMeetVC animated:YES];
            }
            else{
                ViewController *liveVC = [[ViewController alloc] init];
                liveVC.roomId = obj[@"room_id"];
                [self.navigationController pushViewController:liveVC animated:YES];
            }
        }
    }else if([name isEqualToString:@"doctorVerify"]){
        [AppCommondCenter sharedCenter];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    if ([urlStr isEqualToString:self.urlStr] || [urlStr containsString:@"jump_new_page=no"]) {
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

- (void)dealloc
{
    
}
@end
