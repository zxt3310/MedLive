//
//  MutipleVIew.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "LiveView.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^fullScrBlk)(void);
@interface MutipleView : LiveView
@property fullScrBlk screenBlock;
@property UIImageView *micView;
- (void)layoutVideoOffMask:(BOOL)hide;
@end

NS_ASSUME_NONNULL_END
