//
//  UIButton + ImageText.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/2.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SDButtonStyle) {
    SDButtonStyleNormal = 0,
    SDButtonStyleTitleLeft,
    SDButtonStyleTitleUp,
    SDButtonStyleTitleDown
};

@interface UIButton(ImageText)
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, assign) CGRect titleRect;
@property (nonatomic, assign) SDButtonStyle buttonStyle;
@property (nonatomic, assign) CGFloat verSpace;
@end

NS_ASSUME_NONNULL_END
