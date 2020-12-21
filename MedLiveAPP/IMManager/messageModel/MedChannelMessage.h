//
//  MedChannelMessage.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MedChannelMessageTypeChat   = 0,
    MedChannelMessageTypeSignal = 1
} MedChannelMessageType;

UIKIT_EXTERN NSString *const SKLMessageSignal_VideoGrant;
UIKIT_EXTERN NSString *const SKLMessageSignal_VideoDenied;
UIKIT_EXTERN NSString *const SKLMessageSignal_Pointmain;

@interface MedChannelMessage : NSObject <YYModel>
@property (nonatomic,strong) NSString *peerId;
@property (nonatomic,strong) NSString *peerName;
@property (nonatomic,strong) NSString *peerHeadPic;
@property (nonatomic) MedChannelMessageType type;
@end


@interface MedChannelChatMessage : MedChannelMessage
@property (nonatomic,strong) NSString *text;
- (instancetype)initWithText:(NSString *)text;
@end

@interface MedChannelSignalMessage : MedChannelMessage
@property (nonatomic,strong) NSString *signal;
@property (nonatomic,strong) NSString *targetid;
- (instancetype)initWithMessageSignal:(NSString *)signal Target:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
