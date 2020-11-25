//
//  LiveVideoRenderView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveVideoRenderView.h"

@implementation LiveVideoRenderView
{
    //遮罩视图
    LiveRenderMaskView *maskView;
    //占位视图
    UIView *placeView;
    UILabel *tipLabel;
}
@synthesize videoCanvas = _videoCanvas;
@synthesize videoView = _videoView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithMaskDelegate:(id <RenderMaseDelegate>)delegate{
    self = [[LiveVideoRenderView alloc] init];
    if (self) {
        //初始化video视图
        _videoView = [[UIView alloc] initWithFrame:CGRectZero];
        //占位视图  初始化隐藏
        placeView = [[UIView alloc] init];
        placeView.backgroundColor = [UIColor lightGrayColor];
        //占位文字
        tipLabel = [[UILabel alloc] init];
        [placeView addSubview:tipLabel];
        maskView = [[LiveRenderMaskView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_videoView];
        [self addSubview:placeView];
        [self addSubview:maskView];
        
        maskView.maskDelegate = delegate;
        _videoView.backgroundColor = [UIColor ColorWithRGB:44 Green:123 Blue:246 Alpha:1];
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
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
}

- (void)fillTitle:(NSString *)title{
    [maskView fillTitle:title];
}

- (void)showPlaceView:(BOOL)show CenterTip:(NSString *)tip{
    placeView.hidden = !show;
    if (show) {
        tipLabel.text = tip;
    }
}

@end
