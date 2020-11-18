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
#import <WebKit/WebKit.h>

@interface MedLiveWebContoller ()<WKScriptMessageHandler>

@end

@implementation MedLiveWebContoller
{
    WKWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *uc = [[WKUserContentController alloc] init];
    config.userContentController = uc;
    [uc addScriptMessageHandler:self name:@"channelInfo"];
    
    webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
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
