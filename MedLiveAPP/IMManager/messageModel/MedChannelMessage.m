//
//  MedChannelMessage.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedChannelMessage.h"

@implementation MedChannelMessage

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self yy_modelEncodeWithCoder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self yy_modelInitWithCoder:coder];
}
@end


@implementation MedChannelChatMessage

- (instancetype)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        self.type = MedChannelMessageTypeChat;
        self.text = text;
    }
    return self;
}

@end

@implementation MedChannelSignalMessage

- (instancetype)initWithMessageSignal:(NSString *)signal Target:(NSString *)uid
{
    self = [super init];
    if (self) {
        self.type = MedChannelMessageTypeSignal;
        self.signal = signal;
        self.targetid = uid;
    }
    return self;
}

@end
