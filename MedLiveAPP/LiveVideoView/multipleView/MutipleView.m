//
//  MutipleVIew.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MutipleView.h"

@implementation MutipleView
{
    UIButton *scaleBtn;
}
@synthesize videoView = _videoView;
@synthesize videoCanvas = _videoCanvas;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVideoView];
        [self setupScaleBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreen)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)videoView{
    return _videoView;
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

- (void)setupVideoView{
    _videoView = [[UIView alloc] init];
    _videoView.backgroundColor = [UIColor yellowColor];
    [_videoView enableFlexLayout:YES];
    [_videoView setLayoutAttrStrings:@[
        @"flex",@"1"
    ]];
    [self addSubview:_videoView];
}

- (void)setupScaleBtn{
    scaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scaleBtn.hidden = YES;
    [scaleBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [scaleBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
    [scaleBtn enableFlexLayout:YES];
    [scaleBtn setLayoutAttrStrings:@[
        @"width",@"25",
        @"height",@"25",
        @"position",@"absolute",
        @"left",@"20",
        @"top",@"20"
    ]];
    [self addSubview:scaleBtn];
}

- (void)fullScreen{
    if (self.screenBlock) {
        BOOL isFull = self.screenBlock();
        if (isFull) {
            scaleBtn.hidden = NO;
        }else{
            scaleBtn.hidden = YES;
        }
    }
}

@end
