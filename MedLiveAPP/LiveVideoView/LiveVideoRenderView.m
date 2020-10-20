//
//  LiveVideoRenderView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveVideoRenderView.h"
#import "LiveRenderMaskView.h"

@implementation LiveVideoRenderView
{
    //遮罩视图
    LiveRenderMaskView *maskView;
}
@synthesize videoCanvas = _videoCanvas;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化video视图
        _videoView = [[UIView alloc] initWithFrame:CGRectZero];
        maskView = [[LiveRenderMaskView alloc] initWithFrame:CGRectZero];
        [self addSubview:_videoView];
        [self addSubview:maskView];
        
        _videoView.backgroundColor = [UIColor whiteColor];
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

- (void)drawRect:(CGRect)rect{
    //调整视图尺寸
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self).with.insets(padding);
    }];
}

@end
