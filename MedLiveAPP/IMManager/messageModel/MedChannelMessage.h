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

typedef enum : NSUInteger {
    MedMessageSignalTypeStreamDenied = 0,
    MedMessageSignalTypeStreamAllow  = 1
} MedMessageSignalType;

@interface MedChannelMessage : NSObject <YYModel>
@property (nonatomic) MedChannelMessageType messageType;
@property (nonatomic,strong) NSString *peerId;
@end


@interface MedChannelChatMessage : MedChannelMessage
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *headPic;
@property (nonatomic,strong) NSString *context;

- (instancetype)initWithUid:(NSString *)uid Name:(NSString *)name Pic:(NSString *)url Context:(NSString *)text;
@end

@interface MedChannelSignalMessage : MedChannelMessage
@property MedMessageSignalType signalType;
@property NSString *targetId;
- (instancetype)initWithMessageSignal:(MedMessageSignalType) signal Target:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
