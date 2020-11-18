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

@interface MedChannelMessage : NSObject <YYModel>
@property NSString *nickName;
@property NSString *headPic;
@property NSString *context;
@property NSString *peerId;
@property NSData *imageData;

- (instancetype)initWith:(NSString *)name Pic:(NSString *)url Context:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
