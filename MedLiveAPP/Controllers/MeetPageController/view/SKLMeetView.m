//
//  SKLMeetView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/2.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMeetView.h"

@implementation SKLMeetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //创建加载
    UIView *pannel = [[UIView alloc] init];
    [self addSubview:pannel];
    //UIButton *containor_consultation = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *containor_meet = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *containor_live = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *containor_join = [UIButton buttonWithType:UIButtonTypeCustom];
    //[pannel addSubview:containor_consultation];
    [pannel addSubview:containor_meet];
    [pannel addSubview:containor_live];
    [pannel addSubview:containor_join];
    
    //UIImageView *consultation_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meetting_p"]];
    UIImageView *meet_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meet_cre"]];
    UIImageView *live_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boardcast_cre"]];
    UIImageView *join_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meet_join"]];
   // [containor_consultation addSubview:consultation_image];
    [containor_meet addSubview:meet_image];
    [containor_live addSubview:live_image];
    [containor_join addSubview:join_image];
    
    //UILabel *consultation_title = [[UILabel alloc] init];
   // consultation_title.text = @"创建会诊";
    UILabel *meet_title = [[UILabel alloc] init];
    meet_title.text = @"创建会议";
    UILabel *live_title = [[UILabel alloc] init];
    live_title.text = @"创建直播";
    UILabel *join_title = [[UILabel alloc] init];
    join_title.text = @"加入直播";
    
    meet_title.font = live_title.font = join_title.font = [UIFont systemFontOfSize:12];
    meet_title.textAlignment = live_title.textAlignment = join_title.textAlignment = NSTextAlignmentCenter;
    
   // [containor_consultation addSubview:consultation_title];
    [containor_meet addSubview:meet_title];
    [containor_live addSubview:live_title];
    [containor_join addSubview:join_title];
    
    UILabel *introTitle = [[UILabel alloc] init];
    introTitle.text = @"功能介绍";
    [self addSubview:introTitle];
    
    [introTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pannel).with.offset(20);
        make.top.equalTo(pannel.mas_bottom);
    }];
    
    //布局
    CGSize imageSize = CGSizeMake(32, 38);
    CGSize titleSize = CGSizeMake(60, 20);
    NSArray<UIView *> *containorAry = @[containor_meet,containor_live,containor_join];
    [pannel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    
    [containorAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                           withFixedItemLength:60
                                   leadSpacing:40
                                   tailSpacing:40];
    [containorAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pannel);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
//    [consultation_image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(containor_consultation.mas_centerX);
//        make.size.mas_equalTo(imageSize);
//        make.top.equalTo(containor_consultation.mas_top).offset(10);
//    }];
//    [consultation_title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(consultation_image.mas_centerX);
//        make.size.mas_equalTo(titleSize);
//        make.top.equalTo(consultation_image.mas_bottom).offset(5);
//    }];
    
    [meet_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containor_meet.mas_centerX);
        make.size.mas_equalTo(imageSize);
        make.top.equalTo(containor_meet.mas_top).offset(10);
    }];
    [meet_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(meet_image.mas_centerX);
        make.size.mas_equalTo(titleSize);
        make.top.equalTo(meet_image.mas_bottom).offset(5);
    }];
    
    [live_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containor_live.mas_centerX);
        make.size.mas_equalTo(imageSize);
        make.top.equalTo(containor_live.mas_top).offset(10);
    }];
    [live_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(live_image.mas_centerX);
        make.size.mas_equalTo(titleSize);
        make.top.equalTo(live_image.mas_bottom).offset(5);
    }];
    
    [join_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containor_join.mas_centerX);
        make.size.mas_equalTo(imageSize);
        make.top.equalTo(containor_join.mas_top).offset(10);
    }];
    [join_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(join_image.mas_centerX);
        make.size.mas_equalTo(titleSize);
        make.top.equalTo(join_image.mas_bottom).offset(5);
    }];
    
    //功能加载
//    [containor_consultation addTarget:self action:@selector(createConsulation) forControlEvents:UIControlEventTouchUpInside];
    [containor_meet addTarget:self action:@selector(createMeet) forControlEvents:UIControlEventTouchUpInside];
    [containor_live addTarget:self action:@selector(createLive) forControlEvents:UIControlEventTouchUpInside];
    [containor_join addTarget:self action:@selector(joinMeet) forControlEvents:UIControlEventTouchUpInside];
 }

- (void)createConsulation{
    if (self.meetViewDelegate) {
        [self.meetViewDelegate meetViewActCreateConsultation];
    }
}
- (void)createMeet{
    if (self.meetViewDelegate) {
        [self.meetViewDelegate meetViewActCreateMeet];
    }
}
- (void)createLive{
    if (self.meetViewDelegate) {
        [self.meetViewDelegate meetViewActCreateLive];
    }
}
-(void)joinMeet{
    if (self.meetViewDelegate) {
        [self.meetViewDelegate meetViewActJoin];
    }
}
- (void)layoutSubviews{
    
}

@end
