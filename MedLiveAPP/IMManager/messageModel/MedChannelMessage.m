//
//  MedChannelMessage.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedChannelMessage.h"

@implementation MedChannelMessage
- (instancetype)initWith:(NSString *)name Pic:(NSString *)url Context:(NSString *)text
{
    self = [super init];
    if (self) {
        self.nickName = name;
        self.headPic = url;
        self.context = text;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self yy_modelEncodeWithCoder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self yy_modelInitWithCoder:coder];
}
@end
