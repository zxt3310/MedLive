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
    TouchSlideUp,
    TouchSlideDown
} TouchSlideAction;

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



@implementation LiveRenderMaskView
{
    CGPoint touchBeganPoint;
    SliderView *volumeBrightView;
    TouchSlideAction curSlideAction;
    TouchSildeFunction curSlideFunc;
    CGFloat curBright;
    CGFloat curVolume;
    
    UIImage *volImg;
    UIImage *brightImg;
    //系统级私有slider
    UISlider *volumeSlider;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        volImg = [UIImage imageNamed:@"volume"];
        brightImg = [UIImage imageNamed:@"bright"];
        
        volumeBrightView = [[SliderView alloc] init];
        volumeBrightView.alpha = 0;
        [self addSubview:volumeBrightView];
        
        [volumeBrightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(150, 40));
        }];
        
        //隐藏系统音量
        MPVolumeView *volView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        volView.clipsToBounds = YES;
        [self addSubview:volView];
        //遍历出音量组件
        for (UIView *view in volView.subviews) {
            if([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeSlider = (UISlider *)view;
            }
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(systemVolumeDidChange:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
    }
    return self;
}

//触摸回调
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchesBeganWithPoint:point];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchesEndedWithPoint:point];
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
    volumeBrightView.alpha = 1;
}

- (void)touchesEndedWithPoint:(CGPoint) point{
    [UIView animateWithDuration:0.3
                          delay:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self->volumeBrightView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesMovedWithPoint:(CGPoint) point{
    if(fabs(point.x - touchBeganPoint.x) >= 30){
        return;
    }
    float wave = fabs(point.y - touchBeganPoint.y);
    if (wave >= 10){
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



