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

@interface MedLiveWebContoller ()<WKScriptMessageHandler,WKNavigationDelegate>

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
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.layoutView);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.urlStr) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"channelInfo"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"channelInfo"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
            }else if ([self.roomType isEqualToString: @"meeting"])
            {
                SKLMeetJoinMeetController *joinMeetVC = [[SKLMeetJoinMeetController alloc] init];
                joinMeetVC.roomId = obj[@"room_id"];
                [self.navigationController pushViewController:joinMeetVC animated:YES];
            }else if ([self.roomType isEqualToString: @"consultation"])
            {
                
            }
            else{
                ViewController *liveVC = [[ViewController alloc] init];
                liveVC.roomId = obj[@"room_id"];
                [self.navigationController pushViewController:liveVC animated:YES];
            }
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    if ([urlStr isEqualToString:self.urlStr] || [urlStr containsString:@"isjump"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        MedLiveWebContoller *webVC = [[MedLiveWebContoller alloc] init];
        webVC.roomType = @"boardcastRole";
        webVC.urlStr = navigationAction.request.URL.absoluteString;
        [self.navigationController pushViewController:webVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)dealloc
{
    
}
@end
