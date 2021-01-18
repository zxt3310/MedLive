//
//  LiveVideoRemoteWidget.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/12/8.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveVideoRemoteWidget.h"

@implementation LiveVideoRemoteWidget
{
    UIView *placeholder; //摄像头禁用时的画面
}
@synthesize videoView = _videoView;
@synthesize videoCanvas = _videoCanvas;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _videoView = [[UIView alloc] init];
        [self addSubview:_videoView];
        
        placeholder = [[UIView alloc] init];
        placeholder.backgroundColor = [UIColor lightGrayColor];
        placeholder.hidden = YES;
        [self addSubview:placeholder];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"video_off"];
        [placeholder addSubview:icon];
        
        [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.center.equalTo(placeholder);
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

- (void)hidePlaceholder:(BOOL) hide{
    placeholder.hidden = hide;
}

@end
