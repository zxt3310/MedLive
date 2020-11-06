//
//  LiveVideoRenderView.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveVideoRenderView : LiveView

-(id)initWithMaskDelegate:(id <RenderMaseDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
