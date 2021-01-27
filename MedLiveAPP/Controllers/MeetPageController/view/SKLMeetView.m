//
//  SKLMeetView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/2.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMeetView.h"

@implementation SKLMeetView
{
    UIView *pannel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupIntroText];
    }
    return self;
}

- (void)setupUI{
    //创建加载
    pannel = [[UIView alloc] init];
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
    join_title.text = @"快速加入";
    
    meet_title.font = live_title.font = join_title.font = [UIFont systemFontOfSize:12];
    meet_title.textAlignment = live_title.textAlignment = join_title.textAlignment = NSTextAlignmentCenter;
    
   // [containor_consultation addSubview:consultation_title];
    [containor_meet addSubview:meet_title];
    [containor_live addSubview:live_title];
    [containor_join addSubview:join_title];
    
    //布局
    CGSize imageSize = CGSizeMake(32, 38);
    CGSize titleSize = CGSizeMake(60, 20);
    NSArray<UIView *> *containorAry = @[containor_meet,containor_live,containor_join];
    [pannel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self);
        make.height.mas_equalTo(180);
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

- (void)setupIntroText{
    UIView *introView = [[UIView alloc] init];
    [self addSubview:introView];
    
    UILabel *introTitle = [[UILabel alloc] init];
    introTitle.text = @"功能介绍";
    [introView addSubview:introTitle];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 0;
    label1.textColor = [UIColor ColorFromHex:0x909090];
    label1.font = [UIFont systemFontOfSize:14];
    [introView addSubview:label1];
    NSString *introStr = @"将成为全国范围内县域间各级医院自愿结盟的、非营利性的、致力于结直肠肿瘤防控工作的交流合作平台，以“强医生、利病人”为目标，借助“互联网+”等信息化手段，建设远程网络医疗协作体系。";
    NSMutableParagraphStyle *introStyle = [[NSMutableParagraphStyle alloc] init];
    introStyle.lineSpacing = 5;
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:introStr attributes:@{NSParagraphStyleAttributeName:introStyle}];
    label1.attributedText = attr1;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor ColorFromHex:0x909090];
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:14];
    [introView addSubview:label2];
    
    NSString *totalStr = @"联盟成员可以：\n1.借助国家癌症中心优势平台，优先参与众多临床试验项目，获得开展肿瘤研究的学术资源及技术支持；\n2.借助平台搭建便利、规范、高效的远程会诊端口，完善与区域医学中心之间的会诊流程；\n3.借助《中华结直肠疾病电子杂志》平台，享有推荐优秀论文优先发表权利；\n4.借助中国结直肠肿瘤学院，搭建与对应区域教学医院权威专家相互合作平台，合作形式包括：医院共建、科室共建、专家讲座、义诊、线上转播平台的使用、教学资源的共享等；";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    
    NSMutableParagraphStyle *para1 = [[NSMutableParagraphStyle alloc] init];
    para1.lineSpacing = 7;
    NSRange ran1 = [totalStr rangeOfString:@"联盟成员可以："];
    [attr addAttribute:NSParagraphStyleAttributeName value:para1 range:ran1];
    
    NSRange ran2 = [totalStr rangeOfString:@"1.借助国家癌症中心优势平台，优先参与众多临床试验项目，获得开展肿瘤研究的学术资源及技术支持；"];
    [attr addAttribute:NSParagraphStyleAttributeName value:para1 range:ran2];
    
    NSRange ran3 = [totalStr rangeOfString:@"2.借助平台搭建便利、规范、高效的远程会诊端口，完善与区域医学中心之间的会诊流程；"];
    [attr addAttribute:NSParagraphStyleAttributeName value:para1 range:ran3];
    
    NSRange ran4 = [totalStr rangeOfString:@"3.借助《中华结直肠疾病电子杂志》平台，享有推荐优秀论文优先发表权利；"];
    [attr addAttribute:NSParagraphStyleAttributeName value:para1 range:ran4];
    
    NSRange ran5 = [totalStr rangeOfString:@"4.借助中国结直肠肿瘤学院，搭建与对应区域教学医院权威专家相互合作平台，合作形式包括：医院共建、科室共建、专家讲座、义诊、线上转播平台的使用、教学资源的共享等；"];
    [attr addAttribute:NSParagraphStyleAttributeName value:para1 range:ran5];
    
    label2.attributedText = attr;
    
    [introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(pannel.mas_bottom);
    }];
    
    [introTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(introView).offset(20);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(introTitle);
        make.right.equalTo(introView).offset(-20);
        make.top.equalTo(introTitle.mas_bottom).offset(20);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(label1);
        make.top.equalTo(label1.mas_bottom).offset(20);
    }];
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
