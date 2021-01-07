//
//  MainTabController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MainTabController.h"
#import <AxcAE_TabBar/AxcAE_TabBar.h>
#import "SKLMainPageController.h"
#import "SKLMeetController.h"
#import "SKLTeamController.h"
#import "SKLUserCenterController.h"
#import "MedLiveWebContoller.h"

@interface MainTabController ()<AxcAE_TabBarDelegate>

@end

@implementation MainTabController
{
    AxcAE_TabBar *tabbar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKLMainPageController *mainPage = [[SKLMainPageController alloc] init];
    SKLMeetController *meetting = [[SKLMeetController alloc] init];
    SKLTeamController *proTeam = [[SKLTeamController alloc] init];
//    MedLiveWebContoller *proTeam = [[MedLiveWebContoller alloc] init];
//    proTeam.urlStr = @"http://dev.saikang.ranknowcn.com/h5/expert_list";
    
    SKLUserCenterController *userCenter = [[SKLUserCenterController alloc] init];

    self.viewControllers = @[mainPage,meetting,proTeam,userCenter];
    
    AxcAE_TabBarConfigModel *Main = [self ConfigWithDictionary:@{@"title":@"主页",@"icon":@"main"}];
    AxcAE_TabBarConfigModel *meeting = [self ConfigWithDictionary:@{@"title":@"会议",@"icon":@"meetting"}];
    AxcAE_TabBarConfigModel *proteam = [self ConfigWithDictionary:@{@"title":@"专家团队",@"icon":@"proteam"}];
    AxcAE_TabBarConfigModel *user = [self ConfigWithDictionary:@{@"title":@"我的",@"icon":@"user"}];
//    AxcAE_TabBarConfigModel *testmodel = [self ConfigWithDictionary:@{@"title":@"直播测试",@"icon":@"meetting"}];
    
    tabbar = [[AxcAE_TabBar alloc] initWithTabBarConfig:@[Main,meeting,proteam,user]];
    tabbar.backgroundColor = [UIColor whiteColor];
    tabbar.delegate = self;
    [self.tabBar addSubview:tabbar];
}

- (AxcAE_TabBarConfigModel *)ConfigWithDictionary:(NSDictionary *)dic{
    AxcAE_TabBarConfigModel *model = [[AxcAE_TabBarConfigModel alloc] init];
    model.itemTitle = dic[@"title"];
    model.selectColor = [UIColor ColorWithRGB:44 Green:123 Blue:246 Alpha:1];
    model.normalColor = [UIColor ColorWithRGB:122 Green:122 Blue:122 Alpha:1];
    model.selectImageName = [NSString stringWithFormat:@"%@_p",dic[@"icon"]];
    model.normalImageName = [NSString stringWithFormat:@"%@_n",dic[@"icon"]];

    return model;
}

- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
    [self setSelectedIndex:index];
}

- (void)viewDidLayoutSubviews{
    UIEdgeInsets insets = self.view.safeAreaInsets;
    CGRect bounds = self.tabBar.bounds;
    bounds.size.height += insets.bottom;
    tabbar.frame = bounds;
}
@end
