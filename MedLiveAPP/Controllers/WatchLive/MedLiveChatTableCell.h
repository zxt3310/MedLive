//
//  MedLiveChatTableCell.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/20.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedChannelMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveChatTableCell : UITableViewCell
@property (nonatomic) MedChannelChatMessage *message;
@end

NS_ASSUME_NONNULL_END
