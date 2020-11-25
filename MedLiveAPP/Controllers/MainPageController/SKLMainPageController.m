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

@interface SKLMainPageController ()<WKScriptMessageHandler,WKUIDelegate>
@property (strong,readonly) WKWebView *mainWebView;
@end

@implementation SKLMainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *uc = [[WKUserContentController alloc] init];
    config.userContentController = uc;
    [uc addScriptMessageHandler:self name:@"channelInfo"];
    _mainWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    _mainWebView.UIDelegate = self;
    _mainWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:_mainWebView];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/home"]]];
    
    _mainWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.saikang.ranknowcn.com/h5/home"]]];
        [self.mainWebView.scrollView.mj_header endRefreshing];
    }];
    
    [self deleteWebCache];
}

- (void)deleteWebCache {
//allWebsiteDataTypes清除所有缓存
 NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];

    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
//
//        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            completionHandler();
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
//}

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

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    insets.top = kStatusBarHeight;
    [_mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(insets);
    }];
}
@end
