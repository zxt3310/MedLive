//
//  MedLiveheader.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/23.
//  Copyright © 2020 Zxt. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef MedLiveheader_h
#define MedLiveheader_h
#define WeakSelf __weak typeof(self) weakSelf = self;
//域名
#define Domain @"http://dev.saikang.ranknowcn.com"

/* 空字符串替换 */
#define KIsBlankString(str)  [NSString isBlankString:str]
#define Kstr(a) KIsBlankString(a)?@"":a

typedef enum : NSUInteger {
    MedLiveStatePlaying,
    MedLiveStatePausing,
    MedLiveStateStop
} MedLiveState;

typedef enum : NSUInteger {
    MedLiveScreenStateNormal,
    MedLiveScreenStateFullScreen,
} MedLiveScreenState;

typedef enum : NSUInteger {
    MedLiveTypeBordcast,
    MedLiveTypeMeetting
} MedLiveType;

typedef enum : NSUInteger {
    MedLiveRoomStateStart,
    MedLiveRoomStateEnd
} MedLiveRoomState;

#endif /* MedLiveheader_h */



