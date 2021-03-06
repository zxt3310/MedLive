//
//  LiveRenderMaskView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/19.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveRenderMaskView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef enum : NSUInteger {
    TouchSildeFunctionBright,
    TouchSildeFunctionVolume
} TouchSildeFunction;

@interface SliderView : UIView
@property UIImage *icon;
- (void)slideWithValue:(CGFloat)value;

@end

@implementation SliderView
{
    UIProgressView *slider;
    UIImageView *iconView;
}
@synthesize icon = _icon;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        
        slider = [[UIProgressView alloc] init];
        slider.progressTintColor = [UIColor ColorWithRGB:44 Green:123 Blue:246 Alpha:1];
        slider.trackTintColor = [UIColor ColorWithRGB:200 Green:200 Blue:200 Alpha:1];
        [self addSubview:slider];
        
        iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(iconView.mas_right).offset(5);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(@3);
        }];
        
    }
    return self;
}

- (UIImage *)icon{
    return _icon;
}

- (void)setIcon:(UIImage *)icon{
    _icon = icon;
    iconView.image = icon;
}

- (void)dealloc{
    NSLog(@"slider dealloc ok");
}

- (void)slideWithValue:(CGFloat)value{
    slider.progress = value;
}

@end

#pragma mark MaskViewImp
@implementation LiveRenderMaskView
{
    CGPoint touchBeganPoint;
    SliderView *volumeBrightView;
    TouchSildeFunction curSlideFunc;
    CGFloat curBright;
    CGFloat curVolume;
    
    UIImage *volImg;
    UIImage *brightImg;
    //系统级私有slider
    UISlider *volumeSlider;
    //标题 导航
    UIView *titleBar;
    
    //开始暂停 清晰度
    UIView *bottomBar;
    //摄像头 麦克风 下麦
    UIView *sideBar;
    UIButton *camaraBtn;
    UIButton *micBtn;
    UIButton *cancelBtn;
    
    UIButton *playBtn;
    UIButton *screenScaleBtn;
    
    UILabel *titleLb;
    
    BOOL isShow;
    int funcBarHide;
    NSTimer *timer;
    
    //进度条时间
    UISlider *videoSlider;
    UILabel *curPrograssLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        volImg = [UIImage imageNamed:@"volume"];
        brightImg = [UIImage imageNamed:@"bright"];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(systemVolumeDidChange:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
        [self addTarget:self action:@selector(showFunctionBar) forControlEvents:UIControlEventTouchUpInside];
        //[self addTarget:self action:@selector(playAndPauseAction:) forControlEvents:UIControlEventTouchDownRepeat];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //隐藏系统音量
    MPVolumeView *volView = [[MPVolumeView alloc] init];
    volView.userInteractionEnabled = NO;
    volView.clipsToBounds = YES;
    [self addSubview:volView];
    //遍历出音量组件
    for (UIView *view in volView.subviews) {
        if([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
        }
    }
    
    //加载亮度、音量状态条
    volumeBrightView = [[SliderView alloc] init];
    volumeBrightView.alpha = 0;
    [self addSubview:volumeBrightView];
    
    [volumeBrightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    [self buildFounctionBar];
}

//播放进度条
- (void)buildVideoSlider:(NSInteger)videoLength{
    if(videoSlider){
        return;
    }
    videoSlider = [[UISlider alloc] init];
    [bottomBar addSubview:videoSlider];
    
    videoSlider.minimumValue = 0;
    videoSlider.maximumValue = videoLength;
    videoSlider.value = 0;
    [videoSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"] forState:UIControlStateNormal];
    //不连续报告进度
    [videoSlider setContinuous:YES];
    videoSlider.minimumTrackTintColor = [UIColor ColorWithRGB:44 Green:123 Blue:246 Alpha:1];
    videoSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    [videoSlider addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    totalLabel.text = [NSString stringWithFormat:@"/%@",[MedLiveAppUtilies secondToString:videoLength]];
    [bottomBar addSubview:totalLabel];
    
    curPrograssLabel = [[UILabel alloc] init];
    curPrograssLabel.textColor = [UIColor whiteColor];
    curPrograssLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    curPrograssLabel.text = [MedLiveAppUtilies secondToString:0];
    [bottomBar addSubview:curPrograssLabel];
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playBtn.mas_centerY);
        make.right.equalTo(screenScaleBtn.mas_left).offset(-5);
    }];
    
    [curPrograssLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playBtn.mas_centerY);
        make.right.equalTo(totalLabel.mas_left);
    }];
    
    [videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playBtn.mas_centerY);
        make.left.equalTo(playBtn.mas_right).offset(10);
        make.right.equalTo(curPrograssLabel.mas_left).offset(-5);
    }];
}

- (void)sliderValurChanged:(UISlider *)sender forEvent:(UIEvent *)event{
    UITouch *touchEvent = [[event allTouches] anyObject];
    switch (touchEvent.phase) {
            case UITouchPhaseBegan:
                NSLog(@"开始拖动");
                //停止计时
                [timer setFireDate:[NSDate distantFuture]];
                break;
            case UITouchPhaseMoved:
                NSLog(@"正在拖动 %f",sender.value);
                curPrograssLabel.text = [MedLiveAppUtilies secondToString:sender.value];
                break;
            case UITouchPhaseEnded:
                NSLog(@"结束拖动");
                if(self.maskDelegate && [self.maskDelegate respondsToSelector:@selector(videoSliderDidJump:)]){
                    [self.maskDelegate videoSliderDidJump:sender.value];
                }
                //开始计时
                [timer setFireDate:[NSDate date]];
                break;
            default:
                break;
        }
}

//播放进度实时更新
- (void)updateVideoPosition:(NSInteger)point{
    [videoSlider setValue:point animated:NO];
    curPrograssLabel.text = [MedLiveAppUtilies secondToString:point];
}

- (void)buildFounctionBar{
    //加载TitleBar
    titleBar = [[UIView alloc] init];
    [self addSubview:titleBar];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"]
             forState:UIControlStateNormal];
    [backBtn addTarget:self
                action:@selector(quitBtnAction)
      forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [titleBar addSubview:backBtn];
    
    titleLb = [[UILabel alloc] init];
    titleLb.text = @"直播间";
    titleLb.textColor = [UIColor whiteColor];
    [titleBar addSubview:titleLb];
    
    //加载BottomBar
    bottomBar = [[UIView alloc] init];
    [self addSubview:bottomBar];
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [playBtn addTarget:self
                action:@selector(playAndPauseAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:playBtn];
    
    screenScaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [screenScaleBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    [screenScaleBtn addTarget:self
                       action:@selector(screenScaleAction:)
             forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:screenScaleBtn];
    
    //加载sideBar 上麦功能条
    sideBar = [[UIView alloc] init];
    sideBar.hidden = YES;
    sideBar.layer.cornerRadius = 7;
    sideBar.backgroundColor = [UIColor ColorWithRGB:5 Green:5 Blue:5 Alpha:0.5];
    [self addSubview:sideBar];
    camaraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [camaraBtn setImage:[UIImage imageNamed:@"func_cam_off"] forState:UIControlStateNormal];
    [camaraBtn addTarget:self action:@selector(enableCamara:) forControlEvents:UIControlEventTouchUpInside];
    [sideBar addSubview:camaraBtn];
    micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [micBtn setImage:[UIImage imageNamed:@"func_mic_off"] forState:UIControlStateNormal];
    [micBtn addTarget:self action:@selector(enableMic:) forControlEvents:UIControlEventTouchUpInside];
    [sideBar addSubview:micBtn];
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelBtn setImage:[UIImage imageNamed:@"call_off"] forState:UIControlStateNormal];
//    [sideBar addSubview:cancelBtn];
    
    //布局
    [titleBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight-5);
        make.height.mas_equalTo(@40);
    }];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleBar.mas_centerY);
        make.left.equalTo(titleBar.mas_left);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn.mas_centerY);
        make.left.equalTo(backBtn.mas_right);
    }];
    
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(@40);
    }];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBar.mas_top);
        make.left.equalTo(bottomBar.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [screenScaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBar.mas_top);
        make.right.equalTo(bottomBar.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    titleBar.alpha = 0;
    bottomBar.alpha = 0;
    
    [sideBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.width.equalTo(@40);
    }];
    NSArray *btnAry = @[camaraBtn,micBtn];
    [btnAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(sideBar.mas_centerX);
    }];
    [btnAry mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
}

- (void)layoutMarginsDidChange{
    [super layoutMarginsDidChange];
    [sideBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-5 - self.safeAreaInsets.right);
    }];
}

- (void)fillTitle:(NSString *)title{
    titleLb.text = title;
}
//触摸回调
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchesBeganWithPoint:point];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGPointEqualToPoint(point, touchBeganPoint)) {
        [super touchesEnded:touches withEvent:event];
    }else{
        [self touchesEndedWithPoint:point];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchesMovedWithPoint:point];
}

- (void)touchesBeganWithPoint:(CGPoint) point{
    touchBeganPoint = point;
    if(point.x <= self.frame.size.width/2){
        curSlideFunc = TouchSildeFunctionBright;
        volumeBrightView.icon = brightImg;
        curBright = [UIScreen mainScreen].brightness;
        [volumeBrightView slideWithValue:curBright];
    }else{
        curSlideFunc = TouchSildeFunctionVolume;
        volumeBrightView.icon = volImg;
        curVolume = volumeSlider.value;
        [volumeBrightView slideWithValue:curVolume];
    }
}

- (void)touchesEndedWithPoint:(CGPoint) point{
    if (volumeBrightView.alpha == 1) {
        [UIView animateWithDuration:0.3
                              delay:1.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
            self->volumeBrightView.alpha = 0;
        } completion:nil];
    }
}

- (void)touchesMovedWithPoint:(CGPoint) point{
    if(fabs(point.x - touchBeganPoint.x) >= 30){
        return;
    }
    float wave = fabs(point.y - touchBeganPoint.y);
    if (wave >= 10){
        volumeBrightView.alpha = 1;
        //限制滑动最大值
        CGFloat totalVilidateWid = self.bounds.size.height * 2 / 3;
        wave = wave >= totalVilidateWid? totalVilidateWid : wave;
        //换算成比例
        CGFloat wavePercent = wave / totalVilidateWid;
        //区分音量和亮度
        if(curSlideFunc == TouchSildeFunctionVolume){
            CGFloat newVolume;
            if(point.y > touchBeganPoint.y){
                float tmp = curVolume - wavePercent;
                newVolume = tmp>=0?tmp:0;
            }else{
                float tmp = curVolume + wavePercent;
                newVolume = tmp>=1.0?1.0:tmp;
            }
            [volumeBrightView slideWithValue:newVolume];
            [volumeSlider setValue:newVolume animated:NO];
        }else if(curSlideFunc == TouchSildeFunctionBright){
            CGFloat newBright;
            if(point.y > touchBeganPoint.y){
                float tmp = curBright - wavePercent;
                newBright = tmp>=0?tmp:0;
            }else{
                float tmp = curBright + wavePercent;
                newBright = tmp>=1.0?1.0:tmp;
            }
            [volumeBrightView slideWithValue:newBright];
            [[UIScreen mainScreen] setBrightness:newBright];
        }
    }
}

//处理系统音量变化
- (void)systemVolumeDidChange:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    if (![dic[@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"] ) {
        return;
    }
    double newVolume = [dic[@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
    volumeBrightView.alpha = 1;
    volumeBrightView.icon = volImg;
    [volumeBrightView slideWithValue:newVolume];
    [UIView animateWithDuration:0.3
                          delay:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self->volumeBrightView.alpha = 0;
    } completion:nil];
}

//处理功能条隐藏和显示
- (void)showFunctionBar{
    if(!isShow){
        titleBar.alpha = 1;
        bottomBar.alpha = 1;
        isShow = YES;
        funcBarHide = 5;
        self.bottomBarBlock(NO);
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
                funcBarHide--;
                if (funcBarHide == 0) {
                    [timer setFireDate:[NSDate distantFuture]];
                    [UIView animateWithDuration:0.25 animations:^{
                        bottomBar.alpha = 0;
                        titleBar.alpha = 0;
                        isShow = NO;
                    } completion:^(BOOL finished) {
                        self.bottomBarBlock(YES);
                    }];
                }
            }];
        }
        [timer setFireDate:[NSDate date]];
    }else{
        [timer setFireDate:[NSDate distantFuture]];
        titleBar.alpha = 0;
        bottomBar.alpha = 0;
        isShow = NO;
        self.bottomBarBlock(YES);
        NSLog(@"隐藏");
    }
}

//处理上麦功能条
- (void)enableSideBar:(BOOL) enable{
    sideBar.hidden = !enable;
    if (!enable) {
        [camaraBtn setImage:[UIImage imageNamed:@"func_cam_off"] forState:UIControlStateNormal];
        [micBtn setImage:[UIImage imageNamed:@"func_mic_off"] forState:UIControlStateNormal];
    }
}
//被动触发上麦（设备全开）
- (void)openDeviceOnForce{
    [self enableCamara:camaraBtn];
}

- (void)enableCamara:(UIButton *)sender{
    if (self.maskDelegate && [self.maskDelegate respondsToSelector:@selector(switchCamara:)]) {
        [self.maskDelegate switchCamara:^(BOOL enable, BOOL isFirst) {
            if (enable) {
                [sender setImage:[UIImage imageNamed:@"func_cam_on"] forState:UIControlStateNormal];
            }else{
                [sender setImage:[UIImage imageNamed:@"func_cam_off"] forState:UIControlStateNormal];
            }
            
            if (isFirst) {
                [self enableMic:micBtn];
            }
        }];
    }
}
- (void)enableMic:(UIButton *)sender{
    if (self.maskDelegate && [self.maskDelegate respondsToSelector:@selector(switchMic:)]) {
        [self.maskDelegate switchMic:^(BOOL enable) {
            if (enable) {
                [sender setImage:[UIImage imageNamed:@"func_mic_on"] forState:UIControlStateNormal];
            }else{
                [sender setImage:[UIImage imageNamed:@"func_mic_off"] forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma 功能操作回调
- (void)quitBtnAction{
    if(self.maskDelegate){
        __weak UIButton *weakBtn = screenScaleBtn;
        [self.maskDelegate RenderMasekDidTapBack:^(MedLiveScreenState state) {
            if(state == MedLiveScreenStateNormal){
                weakBtn.hidden = NO;
            }else{
                //释放计时器 否则内存泄漏
                [timer invalidate];
                timer = nil;
            }
        }];
    }
}

- (void)playAndPauseAction:(UIButton *)sender{
    if(self.maskDelegate){
        __weak UIButton *weakBtn = playBtn;
        [self.maskDelegate RenderMaskDidSwitchPlayStateComplate:^(MedLiveState state) {
            if(state == MedLiveStatePlaying){
                [weakBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            }else{
                [weakBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)screenScaleAction:(UIButton *)sender{
    if (self.maskDelegate) {
        [self.maskDelegate RenderMaskDidSwitchScreenStateComplate];
    }
    screenScaleBtn.hidden = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"video_prograss") {
        NSInteger value = [[change valueForKey:@"new"] integerValue];
        curPrograssLabel.text = [MedLiveAppUtilies secondToString: value];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



