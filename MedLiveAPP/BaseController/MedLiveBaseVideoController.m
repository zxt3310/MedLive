//
//  MedLiveBaseVideoController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveBaseVideoController.h"

@interface MedLiveBaseVideoController ()

@end

@implementation MedLiveBaseVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)dealloc{
    
}

@end
