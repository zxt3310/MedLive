//
//  LiveVideoRenderView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveVideoRenderView.h"
#import "LiveVideoRemoteWidget.h"

@implementation LiveVideoRenderView
{
    //遮罩视图
    LiveRenderMaskView *maskView;
    //占位视图
    UIView *placeView;
    UILabel *tipLabel;
    
    NSMutableArray <LiveVideoRemoteWidget *> *remoteArray;
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
        //初始化小窗口集合
        remoteArray = [NSMutableArray array];
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
#pragma 远程流 布局
- (void)addRemoteStream:(NSInteger)uid result:(void(^)(__kindof LiveView* remoteView))res{
    __block BOOL isExist = NO;
    [remoteArray enumerateObjectsUsingBlock:^(LiveVideoRemoteWidget *obj, NSUInteger idx, BOOL *stop) {
        if (obj.uid == uid) {
            isExist = YES;
        }
        *stop = YES;
    }];
    
    if (isExist) {
        res(nil);
        return;
    }
    
    if (remoteArray.count >= 3) {
        res(nil);
    }
    else{
        LiveVideoRemoteWidget *remote = [[LiveVideoRemoteWidget alloc] init];
        remote.uid = uid;
        [remoteArray addObject:remote];
        [_videoView.superview addSubview:remote];
        
        [self layoutRemotes:remoteArray];
        res(remote);
    }
}

- (void)removeRemoteStream:(NSInteger)uid{
    __block NSInteger index = 0;
    [remoteArray enumerateObjectsUsingBlock:^(LiveVideoRemoteWidget *obj, NSUInteger idx, BOOL *stop) {
        if (obj.uid == uid) {
            index = idx;
        }
        *stop = YES;
    }];
    
    LiveVideoRemoteWidget *view = [remoteArray objectAtIndex:index];
    if (view.uid == uid) {
        [view removeFromSuperview];
        [remoteArray removeObject:view];
        view = nil;
        [self layoutRemotes:remoteArray];
    }
}

- (void)layoutRemotes:(NSArray <LiveVideoRemoteWidget*>*) remotes{
    CGFloat space = 5.0;
    CGFloat with = kScreenWidth<kScreenHeight?(kScreenWidth - 4*space)/3:(kScreenHeight - 4*space)/3;
    CGFloat height = 80;
    
    for (int i=0;i<remotes.count;i++) {
        LiveVideoRemoteWidget *widget = [remoteArray objectAtIndex:i];
        [widget mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(with, height));
            make.bottom.equalTo(_videoView).offset(-space);
            if (i==0) {
                make.right.equalTo(_videoView).offset(-space);
            }else{
                LiveVideoRemoteWidget *last = [remoteArray objectAtIndex:i-1];
                make.right.equalTo(last.mas_left).offset(-space);
            }
        }];
    }
}

@end
