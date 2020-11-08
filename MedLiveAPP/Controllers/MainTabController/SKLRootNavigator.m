//
//  SKLRootNavigator.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLRootNavigator.h"

@interface SKLRootNavigator ()<UINavigationBarDelegate>

@end

@implementation SKLRootNavigator

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    return YES;
}
@end
