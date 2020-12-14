//
//  LiveVideoRemoteWidget.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/12/8.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveVideoRemoteWidget.h"

@implementation LiveVideoRemoteWidget
@synthesize videoView = _videoView;
@synthesize videoCanvas = _videoCanvas;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _videoView = [[UIView alloc] init];
        [self addSubview:_videoView];
        
        [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setVideoCanvas:(AgoraRtcVideoCanvas *)videoCanvas{
    _videoCanvas = videoCanvas;
    if(self.videoView){
        _videoCanvas.view = self.videoView;
    }
}

- (AgoraRtcVideoCanvas *)videoCanvas{
    return _videoCanvas;
}

@end
