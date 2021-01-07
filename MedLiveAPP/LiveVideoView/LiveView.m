//
//  LiveView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveView.h"

@implementation LiveView

- (void)renewVideoView{
    UIView *newView = [[UIView alloc] init];
    newView.backgroundColor = self.videoView.backgroundColor;
    NSInteger cur = [self.subviews indexOfObject:self.videoView];
    [self insertSubview:newView atIndex:cur];
    [self.videoView removeFromSuperview];
    self.videoView = newView;
    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
	
@end
