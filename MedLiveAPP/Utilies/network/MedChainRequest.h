//
//  MedChainRequest.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MedBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class MedChainRequest;
typedef void(^MedChainReqBlock)(MedChainRequest* chainReq,MedBaseRequest* request);

@interface MedChainRequest : NSObject

@end

NS_ASSUME_NONNULL_END
