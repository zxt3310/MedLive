//
//  LiveVideoTipMask.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/7.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "LiveVideoTipMask.h"

@implementation LiveVideoTipMask
{
    UILabel *tipLabel;
    UIView *countView;
    UILabel *countLabel;
    NSTimer *timer;
}
//@synthesize backPlayBtn = _backPlayBtn;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //遮罩
        UIView *mask = [[UIView alloc] init];
        mask.backgroundColor = [UIColor ColorWithRGB:5 Green:5 Blue:5 Alpha:0.5];
        [self addSubview: mask];
        //非倒计时提示语
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = [UIFont systemFontOfSize:20];
        tipLabel.hidden = YES;
        tipLabel.text = @"加载中...";
        [mask addSubview:tipLabel];
        
        _backPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backPlayBtn setTitle:@"观看回放" forState:UIControlStateNormal];
        _backPlayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _backPlayBtn.titleLabel.textColor = [UIColor whiteColor];
        _backPlayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _backPlayBtn.layer.borderWidth = 1;
        _backPlayBtn.layer.cornerRadius = 10;
        _backPlayBtn.hidden = YES;
        [_backPlayBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [mask addSubview:_backPlayBtn];
        
        //倒计时view
        countView = [[UIView alloc] init];
        [mask addSubview:countView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"距离开播还剩：";
        [countView addSubview:titleLabel];
        
        countLabel = [[UILabel alloc] init];
        countLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        countLabel.textColor = [UIColor whiteColor];
        [countView addSubview:countLabel];
        
        [mask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(mask);
        }];
        [_backPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(mask);
            make.centerY.equalTo(tipLabel).offset(50);
            make.size.mas_equalTo(CGSizeMake(100, 35));
        }];
        [countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(mask);
            make.centerY.equalTo(mask).offset(-20);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(countView);
        }];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(countView);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(30);
        }];
        
    }
    return self;
}

- (void)playVideo:(UIButton *)sender{
    sender.enabled = NO;
    [MedLiveAppUtilies showLoading:@"加载中"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MedLiveHistoryBackPlay object:nil];
    
    //防误触
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (void)countWithStartTime:(NSString *)start State:(MedLiveRoomState)state{
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formater.locale = [NSLocale currentLocale];
    NSDate *startDate = [formater dateFromString:start];
    WeakSelf
    __block NSInteger dif = [startDate timeIntervalSinceNow];
    __weak UILabel *weakLb = countLabel;
    if (dif>0 && !timer) {
        timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (dif == 0) {
                [timer invalidate];
                self->timer = nil;
                return;
            }
            dif--;
            NSInteger day = dif/(24*3600);
            NSInteger hour = dif%(24*3600)/3600;
            NSInteger munite = dif%(24*3600)%3600/60;
            NSInteger second = dif%(24*3600)%3600%60;
            NSString *countStr = [NSString stringWithFormat:@"%02ld天%02ld时%02ld分%02ld秒",day,hour,munite,second];
            weakLb.attributedText = [weakSelf countDownStr:countStr];
        }];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
    }else{
        countView.hidden = YES;
        tipLabel.hidden = NO;
        _backPlayBtn.hidden = YES;
        switch (state) {
            case MedLiveRoomStateStart:
            case MedLiveRoomStateCreated:
                tipLabel.text = @"主播正在加速赶来";
                break;
            case MedLiveRoomStateEnd:
                tipLabel.text = @"直播已结束";
                break;
            case MedLiveRoomStateNoCamara:
                tipLabel.text = @"摄像头未开启";
                break;
            case MedLiveRoomStateEndAndBackplay:
                tipLabel.text = @"直播已结束";
                _backPlayBtn.hidden = NO;
                break;
            default:
                break;
        }
    }
    
}

- (NSAttributedString *)countDownStr:(NSString *)str{

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str]; //attributes:@{NSKernAttributeName:@(5)}];
    [attrStr addAttribute:NSKernAttributeName value:@(8) range:NSMakeRange(1, 2)];
    [attrStr addAttribute:NSKernAttributeName value:@(8) range:NSMakeRange(4, 2)];
    [attrStr addAttribute:NSKernAttributeName value:@(8) range:NSMakeRange(7, 2)];
    [attrStr addAttribute:NSKernAttributeName value:@(8) range:NSMakeRange(10, 2)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:22] range:NSMakeRange(0, 2)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:22] range:NSMakeRange(3, 2)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:22] range:NSMakeRange(6, 2)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:22] range:NSMakeRange(9, 2)];
    return [attrStr copy];
}

- (void)removeFromSuperview{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
