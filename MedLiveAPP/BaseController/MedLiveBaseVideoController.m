//
//  MedLiveBaseVideoController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveBaseVideoController.h"

@interface MedLiveBaseVideoController ()<UIGestureRecognizerDelegate>

@end

@implementation MedLiveBaseVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
    
}

- (void)dealloc{
    
}

@end
