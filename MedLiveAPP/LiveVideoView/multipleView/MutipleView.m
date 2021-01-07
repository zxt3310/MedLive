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
    UIView *maskView;
}
@synthesize videoView = _videoView;
@synthesize videoCanvas = _videoCanvas;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVideoView];
        [self setupScaleBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(fullScreen)];
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
    _videoView.backgroundColor = [UIColor whiteColor];
    [_videoView enableFlexLayout:YES];
    [_videoView setLayoutAttrStrings:@[
        @"flex",@"1"
    ]];
    [self addSubview:_videoView];
    //禁用摄像头遮罩
    maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor ColorWithRGB:160 Green:160 Blue:160 Alpha:1];
    maskView.hidden = YES;
    [maskView enableFlexLayout:YES];
    [maskView setLayoutAttrStrings:@[
        @"flex",@"1",
        @"width",@"100%",
        @"height",@"100%",
        @"position",@"absolute",
        @"justifyContent",@"center",
        @"alignItems",@"center"
    ]];
    UIImageView *cameraOffView = [[UIImageView alloc] init];
    cameraOffView.image = [UIImage imageNamed:@"video_off"];
    [cameraOffView enableFlexLayout:YES];
    [cameraOffView setLayoutAttrStrings:@[
        @"width",@"64",
        @"height",@"64"
    ]];
    [maskView addSubview:cameraOffView];
    [self addSubview:maskView];
    
    _micView = [[UIImageView alloc] init];
    [_micView enableFlexLayout:YES];
    _micView.image = [UIImage imageNamed:@"mic"];
    _micView.hidden = YES;
    [_micView setLayoutAttrStrings:@[
        @"left",@"10",
        @"bottom",@"10",
        @"width",@"20",
        @"aspectRatio",@"1",
        @"position",@"absolute"
    ]];
    [self addSubview:_micView];
}

- (void)layoutVideoOffMask:(BOOL)hide{
    maskView.hidden = hide;
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
        @"left",@"15",
        @"top",@"20",
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
