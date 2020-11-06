//
//  AppPreLaunch.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AppPreLaunch.h"
#import "MedLiveNetManager.h"

@implementation AppPreLaunch

+ (void)preparBeforUI{
    [MedLiveNetManager setBaseUrl:Domain];
    
}

@end
