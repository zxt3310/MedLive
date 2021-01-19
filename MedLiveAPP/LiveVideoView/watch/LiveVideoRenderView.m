//
//  LiveVideoRenderView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveVideoRenderView.h"
#import "LiveVideoRemoteWidget.h"
#import "LiveVideoTipMask.h"
#import <YYWebImage.h>

@implementation LiveVideoRenderView
{
    //遮罩视图
    LiveRenderMaskView *maskView;
    //占位视图
    UIView *placeView;
    //UILabel *tipLabel;
    UIImageView *coverPic;
    LiveVideoTipMask *tipMask;
    
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
        //初始化小窗口底边距
        self.remoteWidgetBottom = -5;
        //初始化小窗口集合
        remoteArray = [NSMutableArray array];
        //初始化video视图
        _videoView = [[UIView alloc] initWithFrame:CGRectZero];
        //占位视图  初始化隐藏
        placeView = [[UIView alloc] init];
        placeView.backgroundColor = [UIColor lightGrayColor];
        
        //占位封面
        coverPic = [[UIImageView alloc] init];
        [placeView addSubview:coverPic];
        //遮罩
        tipMask = [[LiveVideoTipMask alloc] init];
        [placeView addSubview:tipMask];
        
        maskView = [[LiveRenderMaskView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_videoView];
        [self addSubview:placeView];
        [self addSubview:maskView];
        
        maskView.maskDelegate = delegate;
        _videoView.backgroundColor = [UIColor ColorWithRGB:44 Green:123 Blue:246 Alpha:1];
        
        WeakSelf
        __weak NSMutableArray *weakAry = remoteArray;
        maskView.bottomBarBlock = ^(BOOL hidden) {
            weakSelf.remoteWidgetBottom = hidden? -5.0 : -40.0;
            [weakSelf layoutRemotes:weakAry];
        };
        
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

    [coverPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(placeView);
    }];
    [tipMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(placeView);
    }];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
}

- (void)fillTitle:(NSString *)title{
    [maskView fillTitle:title];
}

- (void)enableSideBar:(BOOL)enable{
    [maskView enableSideBar:enable];
}

- (void)showPlaceView:(BOOL)show Start:(NSString *)startTime State:(MedLiveRoomState)state coverPic:(NSString *)img{
    placeView.hidden = !show;
    if (show) {
        //tipLabel.text = tip;
        [tipMask countWithStartTime:startTime State:state];
        if (img) {
            coverPic.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Cdn_domain,img]];
        }
    }
}
#pragma 远程流 布局
- (void)addRemoteStream:(NSInteger)uid result:(void(^)(__kindof LiveView* remoteView))res{
    BOOL isExist = NO;
    for (LiveVideoRemoteWidget *view in remoteArray) {
        if (view.uid == uid) {
            isExist = YES;
            break;
        }
    }
    
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
    NSInteger index = 0;
    //由于主播未开摄像头，在离开的时候依然会收到退出消息，所以做个处理
    if (remoteArray.count == 0) {
        return;
    }
    
    for (int i=0; i<remoteArray.count; i++) {
        LiveVideoRemoteWidget *view = remoteArray[i];
        if (view.uid == uid) {
            index = i;
        }
    }
    
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
            make.bottom.equalTo(self).offset(self.remoteWidgetBottom);
            if (i==0) {
                make.right.equalTo(self).offset(-space);
            }else{
                LiveVideoRemoteWidget *last = [remoteArray objectAtIndex:i-1];
                make.right.equalTo(last.mas_left).offset(-space);
            }
        }];
    }
}

//设置关闭摄像头的远端流 为默认画面 返回是否找到该流
- (BOOL)remote:(NSInteger)uid DidEnabledCamara:(BOOL)enabled{
    for (LiveVideoRemoteWidget *widget in remoteArray) {
        if (widget.uid == uid) {
            [widget hidePlaceholder:enabled];
            return YES;
        }
    }
    return NO;
}

//私有函数 被动触发 强制开启摄像头和麦克风 （上麦弹窗的接受选项）
- (void)deviceOnForce{
    [maskView openDeviceOnForce];
}

- (void)dealloc{
    NSLog(@"RenderView release ok");
}

@end
