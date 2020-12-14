//
//  MedBordcastView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBordcastView.h"

@implementation MedBordcastView
@synthesize videoCanvas = _videoCanvas;
@synthesize videoView = _videoView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
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

- (void)setupUI{
    _videoView = [[UIView alloc] init];
    [self addSubview:_videoView];
    
    UIView *maskView = [[UIView alloc] init];
    [self addSubview:maskView];
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitBtn setTitle:@"退出直播" forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:[UIColor redColor]];
    [quitBtn addTarget:self action:@selector(levealChannel) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:quitBtn];
    
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(20);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

- (void)levealChannel{
    if(self.bordcastDelegate){
        [self.bordcastDelegate bordcastViewDidEnd];
    }
}

@end
