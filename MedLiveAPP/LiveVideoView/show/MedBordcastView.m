//
//  MedBordcastView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedBordcastView.h"
#import "MedLiveChatTableCell.h"
@interface MedBordcastView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MedBordcastView
{
    UITableView *chatTable;
    NSMutableArray *msgAry;
}
@synthesize videoCanvas = _videoCanvas;
@synthesize videoView = _videoView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        msgAry = [NSMutableArray array];
        [self setupUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChatMesaage:) name:RTMEngineDidReceiveMessage object:nil];
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
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quitBtn.layer.cornerRadius = 5;
    [quitBtn setTitle:@"结束直播" forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:[UIColor redColor]];
    [quitBtn addTarget:self action:@selector(levealChannel) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:quitBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:backBtn];
    
    chatTable = [[UITableView alloc] init];
    chatTable.delegate = self;
    chatTable.dataSource = self;
    chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTable.backgroundView = nil;
    chatTable.backgroundColor = [UIColor clearColor];
    chatTable.rowHeight = UITableViewAutomaticDimension;
    chatTable.estimatedRowHeight = 50;
    [maskView addSubview:chatTable];
    
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(kStatusBarHeight);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(quitBtn);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [chatTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(maskView);
        make.bottom.equalTo(maskView).offset(-kBottomSafeHeight);
        make.height.mas_equalTo(kScreenHeight/5*2);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MedLiveChatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MedLiveChatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setBoardcastStyle];
    }
    cell.message = msgAry[indexPath.item];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return msgAry.count;
}

- (void)receiveChatMesaage:(NSNotification *)notify{
    MedChannelChatMessage *msg = (MedChannelChatMessage *)notify.object;
    if (msg) {
        [self addMsg:msg];
    }
}

- (void)addMsg:(MedChannelChatMessage *)msg{
    if (msg) {
        [msgAry addObject:msg];
        [chatTable reloadData];
        if (msgAry.count >0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:msgAry.count - 1 inSection:0];
            [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

- (void)levealChannel{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(self.bordcastDelegate){
        [self.bordcastDelegate bordcastViewDidEnd:YES];
    }
}

- (void)back:(UIButton *)sender{
    if(self.bordcastDelegate){
        [self.bordcastDelegate bordcastViewDidEnd:NO];
    }
}

@end
