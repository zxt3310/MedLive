//
//  MedLiveInteractView.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveInteractView.h"
#import <YYWebImage.h>

@interface MedLiveInteractView() <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak) id<interactViewDelegate> viewDelegate;
@end

@implementation MedLiveInteractView
{
    UIView *line;
    UIView *infoBarView;
    UIButton *chatBtn;
    UIButton *infoBtn;
    UIScrollView *horizonScroll;
    //文本输入区域
    UIView *chatTextView;
    UIView *chatScroll;
    UIScrollView *infoScroll;
    
    UITextField *chatField;
    UIButton *sendBtn;
    UITableView *chatTable;
    
    NSMutableArray <MedChannelChatMessage *> *dataAry;
}

- (instancetype)initWithViewDelegate:(id<interactViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.viewDelegate = delegate;
        [self setupInfoBar];
        [self setupContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardTrack:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChatMesaage:) name:RTCEngineDidReceiveMessage object:nil];
        self.clipsToBounds = YES;
        
        dataAry = [NSMutableArray array];
    }
    return self;
}

- (void)setupInfoBar{
    //信息条容器
    infoBarView = [[UIView alloc] init];
    [self addSubview:infoBarView];
    //详情button
    infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setTitle:@"详情" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(infoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [infoBarView addSubview:infoBtn];
    //互动button
    chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setTitle:@"互动" forState:UIControlStateNormal];
    [chatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [infoBarView addSubview:chatBtn];
    //收藏button
    UIButton *loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loveBtn setImage:[UIImage imageNamed:@"love_n"] forState:UIControlStateNormal];
    [loveBtn addTarget:self action:@selector(loveTap) forControlEvents:UIControlEventTouchUpInside];
    [infoBarView addSubview:loveBtn];
    //分享button
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareTap) forControlEvents:UIControlEventTouchUpInside];
    [infoBarView addSubview:shareBtn];
    //按钮 标志线
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    [infoBarView addSubview:line];
    
    //布局
    [infoBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_top).offset(50);
    }];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(infoBarView);
        make.left.equalTo(infoBarView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(infoBarView);
        make.left.equalTo(infoBtn.mas_right).with.offset(20);
        make.size.equalTo(infoBtn);
    }];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(infoBarView);
        make.right.equalTo(infoBarView).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(infoBarView);
        make.right.equalTo(shareBtn.mas_left).with.offset(-20);
        make.size.equalTo(shareBtn);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(infoBtn);
        make.height.mas_equalTo(2);
        make.top.equalTo(infoBtn.mas_bottom);
    }];
}

- (void)setupContext{
    //横向滚动
    horizonScroll = [[UIScrollView alloc] init];
    horizonScroll.pagingEnabled = YES;
    horizonScroll.delegate = self;
    horizonScroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:horizonScroll];

    //详情
    infoScroll = [[UIScrollView alloc] init];
    [horizonScroll addSubview:infoScroll];
    //互动
    chatScroll = [[UIView alloc] init];
    [horizonScroll addSubview:chatScroll];
    
    [horizonScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(infoBarView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];

    [infoScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(horizonScroll);
        make.width.equalTo(horizonScroll.mas_width);
        make.height.equalTo(horizonScroll.mas_height);
    }];

    [chatScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizonScroll);
        make.left.equalTo(infoScroll.mas_right);
        make.width.equalTo(horizonScroll.mas_width);
        make.height.equalTo(horizonScroll.mas_height);
    }];
    
    [self chatScrollSetupSubview];
}

- (void)chatScrollSetupSubview{
    chatTable = [[UITableView alloc] init];
    chatTable.delegate = self;
    chatTable.dataSource = self;
    chatTable.estimatedRowHeight = 80;
    chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTable.rowHeight = UITableViewAutomaticDimension;
    [chatScroll addSubview:chatTable];
    
    chatTextView = [[UIView alloc] init];
    chatTextView.backgroundColor = [UIColor whiteColor];
    [chatScroll addSubview:chatTextView];
    
    chatField = [[UITextField alloc] init];
    chatField.layer.borderWidth = 1;
    chatField.layer.cornerRadius = 12;
    chatField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    chatField.leftViewMode = UITextFieldViewModeAlways;
    chatField.placeholder = @"输入内容";
    [chatTextView addSubview:chatField];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor blueColor]];
    sendBtn.layer.cornerRadius = 5;
    [sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [chatTextView addSubview:sendBtn];
    
    [chatTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(chatScroll);
        make.bottom.equalTo(chatScroll.mas_bottom).offset(-40);
    }];
    
    [chatTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(chatScroll);
        make.height.mas_equalTo(40);
    }];
    
    [chatField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chatTextView.mas_centerY);
        make.left.equalTo(chatTextView).offset(30);
        make.right.equalTo(chatTextView).offset(-80);
        make.height.mas_equalTo(30);
    }];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chatTextView);
        make.left.equalTo(chatField.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(60,30));
    }];
}

- (void)setupIntorduceScroll{
    if (self.viewDelegate) {
        [self.viewDelegate interactViewNeedSetupIntroduce:^(NSString *title,NSString* startTime, NSString * introStr, NSArray<NSString *> *pics) {
            [self setupIntroduce:title Start:startTime Intro:introStr Pics:pics];
        }];
    }
}

- (void)setupIntroduce:(NSString*)title Start:(NSString *)startTime Intro:(NSString *)introStr Pics:(NSArray <NSString*>*) pics{
    //主题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    [infoScroll addSubview:titleLabel];
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor ColorWithRGB:180 Green:180 Blue:180 Alpha:1];
    timeLabel.text = startTime;
    [infoScroll addSubview:timeLabel];
    //介绍
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.font = [UIFont systemFontOfSize:12];
    introLabel.numberOfLines = 0;
    introLabel.text = introStr;
    [infoScroll addSubview:introLabel];
    
    UIView *picsView = [[UIView alloc] init];
    [infoScroll addSubview:picsView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(infoScroll).offset(20);
        make.width.lessThanOrEqualTo(@(infoScroll.frame.size.width - 40));
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(titleLabel);
    }];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(20);
        make.left.equalTo(timeLabel);
        make.width.lessThanOrEqualTo(@(infoScroll.frame.size.width - 40));
    }];
    [picsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(infoScroll.frame.size.width - 40));
        make.top.equalTo(introLabel.mas_bottom).offset(5);
        make.left.equalTo(introLabel);
        //make.height.mas_equalTo(250*pics.count);
    }];
    //图片
    if (pics) {
        NSMutableArray <UIImageView *>* picsViewAry = [NSMutableArray array];
        WeakSelf
        __weak UIScrollView *weakScroll = infoScroll;
        [pics enumerateObjectsUsingBlock:^(NSString * path, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] init];
            NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@:8081%@",Domain,path]];
            [imageView yy_setImageWithURL:imgUrl
                              placeholder:nil
                                  options:kNilOptions
                               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                if (!image) {
                    return;
                }
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    CGFloat oriWidth = image.size.width;
                    CGFloat oriHei = image.size.height;
                    make.height.mas_equalTo(oriHei/oriWidth*(kScreenWidth - 40));
                }];
//                [imageView.superview layoutIfNeeded];
                [imageView.superview setNeedsLayout];
                [imageView.superview layoutIfNeeded];
                [weakSelf reloadScrollContentSize:weakScroll];
            }];
            //imageView.clipsToBounds = YES;
            [picsViewAry addObject:imageView];
            [picsView addSubview:imageView];
        }];
        //多个图片等间距排版
        if (pics.count > 1) {
            [picsViewAry mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:20 tailSpacing:20];
            [picsViewAry mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(picsView);
            }];
            
        }else if(pics.count == 1){
            UIImageView *imgView = [picsViewAry firstObject];
            [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(picsView);
            }];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC*1.5)), dispatch_get_main_queue(), ^{
        [self reloadScrollContentSize:infoScroll];
    });
}

- (void)resetScroll{
    [self infoBtnAction:infoBtn];
}

//计算scrollview的content size
- (void)reloadScrollContentSize:(UIScrollView *)scrollView{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *aee = [NSMutableArray array];
    [[scrollView subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [arr addObject:@(CGRectGetMaxX(obj.frame))];
        [aee addObject:@(CGRectGetMaxY(obj.frame))];
    }];
    
    for (int i=0; i<arr.count-1; i++) {
        CGFloat aaa = [arr[i] doubleValue];
        CGFloat bbb = [arr[i+1] doubleValue];
        if (aaa>bbb) {
            [arr exchangeObjectAtIndex:i withObjectAtIndex:i+1];
        }
    }
    for (int i=0;i<aee.count -1; i++) {
        CGFloat aaa = [aee[i] doubleValue];
        CGFloat bbb = [aee[i+1] doubleValue];
        if (aaa>bbb) {
            [aee exchangeObjectAtIndex:i withObjectAtIndex:i+1];
        }
    }
    
    [scrollView setContentSize:CGSizeMake([[arr lastObject] doubleValue], [[aee lastObject] doubleValue])];
}
//选项卡及滚动样式变换
- (void)infoBtnAction:(UIButton *)sender{
    [self followInfoBtn];
    [horizonScroll setContentOffset:CGPointZero animated:YES];
}

- (void)chatBtnAction:(UIButton *)sender{
    [self followChatBtn];
    [horizonScroll setContentOffset:CGPointMake(horizonScroll.bounds.size.width, 0) animated:YES];
}
//分享
- (void)shareTap{
    if (self.viewDelegate) {
        [self.viewDelegate interactViewDidShareWithUrl:^{
            NSLog(@"已复制到剪切板");
            [MedLiveAppUtilies showErrorTip:@"已复制"];
        }];
    }
}
//收藏
- (void)loveTap{
    if (self.viewDelegate) {
        [self.viewDelegate interactViewDidStoreLove:NO];
    }
}

- (void)followInfoBtn{
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(infoBtn);
        make.height.mas_equalTo(2);
        make.top.equalTo(infoBtn.mas_bottom);
    }];
}

- (void)followChatBtn{
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(chatBtn);
        make.height.mas_equalTo(2);
        make.top.equalTo(chatBtn.mas_bottom);
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([scrollView isMemberOfClass:[UIScrollView class]]){
        CGPoint offset = scrollView.contentOffset;
        if (offset.x >= horizonScroll.bounds.size.width) {
            [self followChatBtn];
        }else{
            [self followInfoBtn];
        }
    }
}

- (void)layoutSubviews{
    NSLog(@"调用了一次");
    //[self reloadScrollContentSize:horizonScroll];
}

- (void)updateConstraints{
    [super updateConstraints];
    
}

- (void)keyboardTrack:(NSNotification *)notify{
    //获取键盘弹出或收回时frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘弹出所需时长
    float duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //中心起点
    CGRect rectBegin = [notify.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //中心终点
    CGRect rectEnd = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if(rectBegin.origin.y > rectEnd.origin.y){
        //升起
        [UIView animateWithDuration:duration animations:^{
            [chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(chatScroll.mas_bottom).offset(-keyboardFrame.size.height + kBottomSafeHeight);
            }];
            [chatScroll layoutIfNeeded];
        }];
    }else{
        //落下
        [UIView animateWithDuration:duration animations:^{
            [chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(chatScroll.mas_bottom);
            }];
            [chatScroll layoutIfNeeded];
        }];
    }
}

#pragma UITableViewDataSource IMP

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MedLiveChatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MedLiveChatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.message = dataAry[indexPath.row];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  dataAry.count;
}

#pragma SendMessage
- (void)sendMessage:(UIButton *)sender{
    NSString *msg = chatField.text;
    if (KIsBlankString(msg)) {
        NSLog(@"不要发送空信息");
        [MedLiveAppUtilies showErrorTip:@"输入消息内容"];
        return;
    }
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(interactViewDidSendmessage:Complete:)]) {
        [self.viewDelegate interactViewDidSendmessage:msg Complete:^(MedChannelChatMessage* msg){
            chatField.text = @"";
            [self freshChatTableWithMessage:msg];
            [self endEditing:YES];
        }];
    }
}

- (void)freshChatTableWithMessage:(MedChannelChatMessage *)msg{
    [dataAry addObject:msg];
    [chatTable reloadData];
    
    if (dataAry.count >0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dataAry.count - 1 inSection:0];
        [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)receiveChatMesaage:(NSNotification *)notify{
    MedChannelChatMessage *msg = (MedChannelChatMessage *)notify.object;
    if (msg) {
        [self freshChatTableWithMessage:msg];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (![view isEqual:sendBtn]) {
        [self endEditing:YES];
    }
    return view;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
