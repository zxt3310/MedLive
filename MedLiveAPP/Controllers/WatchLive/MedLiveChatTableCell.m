//
//  MedLiveChatTableCell.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/20.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveChatTableCell.h"
#import <YYWebImage.h>


@implementation MedLiveChatTableCell
{
    UIImageView *headerView;
    UILabel *nameLabel;
    UIView *contentView;
    UILabel *contentLabel;
    UIView *containorView;
}
@synthesize message = _message;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupContent];
        
    }
    return self;
}

- (void)setupContent{
    containorView = [[UIView alloc] init];
    [self.contentView addSubview:containorView];
    
    headerView = [[UIImageView alloc] init];
    headerView.image = [UIImage imageNamed:@"header"];
    headerView.layer.cornerRadius = 15;
    headerView.clipsToBounds = YES;
    [containorView addSubview:headerView];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [containorView addSubview:nameLabel];
    
    contentView = [[UIView alloc] init];
    contentView.layer.borderWidth = 1;
    contentView.layer.cornerRadius = 5;
    [containorView addSubview:contentView];
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:contentLabel];
    //
    contentLabel.preferredMaxLayoutWidth = kScreenWidth * 0.6;
    [contentLabel setContentHuggingPriority:UILayoutPriorityRequired
                                    forAxis:UILayoutConstraintAxisHorizontal];
    
    //布局
    [containorView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
        make.edges.equalTo(self.contentView).with.insets(padding);
    }];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(containorView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(5);
        make.left.equalTo(headerView.mas_right).with.offset(8);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_right).with.offset(10);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(8);
        make.right.lessThanOrEqualTo(containorView.mas_right).with.offset(-40);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
        make.edges.equalTo(contentView).with.insets(padding);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (MedChannelChatMessage *)message{
    return _message;
}

- (void)setMessage:(MedChannelChatMessage *)message{
    _message = message;
    nameLabel.text = KIsBlankString(message.peerName)?message.peerId:message.peerName;
    contentLabel.text = message.text;
    if (!KIsBlankString(message.peerHeadPic)) {
        headerView.yy_imageURL = [NSURL URLWithString:message.peerHeadPic];
    }else{
        headerView.image = [UIImage imageNamed:@"head"];
    }
    
    [containorView layoutIfNeeded];
    
    CGFloat height = nameLabel.bounds.size.height + 5 + 8 + contentView.bounds.size.height;
    [containorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priorityHigh();
    }];
}

@end
