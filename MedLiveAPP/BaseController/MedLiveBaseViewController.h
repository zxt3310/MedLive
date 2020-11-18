//
//  MedLiveBaseViewController.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/17.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedLiveBaseViewController : UIViewController
@property (nonatomic) UIColor *navigationColor;
@property (nonatomic) UIColor *navigationTextColor;
@property (nonatomic) UIFont *titleFont;
@property (readonly) UIView *layoutView;
@end

NS_ASSUME_NONNULL_END
