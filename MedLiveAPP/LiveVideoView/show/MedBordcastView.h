//
//  MedBordcastView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BordcastViewDelegate <NSObject>
@optional
- (void)bordcastViewDidEnd:(BOOL)endLive;
@end

@interface MedBordcastView :LiveView
@property (weak) id<BordcastViewDelegate> bordcastDelegate;
@end

NS_ASSUME_NONNULL_END
