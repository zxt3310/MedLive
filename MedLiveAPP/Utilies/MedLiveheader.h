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
#define Cdn_domain [NSString stringWithFormat:@"%@:8081",Domain]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)


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
    MedLiveRoomStateCreated = 1,
    MedLiveRoomStateStart = 2,
    MedLiveRoomStateEnd = 3,
    MedLiveRoomStateNoCamara = 999
} MedLiveRoomState;

typedef enum : NSUInteger {
    MedLiveRoleStateJoin,
    MedliveRoleStateLeave
} MedLiveRoleState;
#endif /* MedLiveheader_h */



