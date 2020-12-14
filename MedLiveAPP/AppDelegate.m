//
//  AppDelegate.m
//  MedLiveAPP
//
//  Created by Zxt on 2020/8/27.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AppDelegate.h"
#import "SKLRootNavigator.h"
#import "MainTabController.h"
#import "AppPreLaunch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlexRestorePreviewSetting();
    //启动准备
    [AppPreLaunch preparBeforUI];
    
    MainTabController *mainTab = [[MainTabController alloc] init];
    SKLRootNavigator *root = [[SKLRootNavigator alloc] initWithRootViewController:mainTab];
    [[self window] setRootViewController:root];
    [[self window] makeKeyAndVisible];
    [AppCommondCenter sharedCenter].currentUser;
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if(_allowRotation == YES){
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        id<ThirdPlatDelegate> delegate = [AppCommondCenter sharedCenter].evocateDelegate;
        if (delegate)
        {
            //进行我们的处理
            [delegate appDidEvocatedToLiveWithUrl:userActivity.webpageURL];
        }
    }
    return YES;
}

@end
