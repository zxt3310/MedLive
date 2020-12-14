//
//  MedChainRequest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/10/30.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedChainRequest.h"

@interface MedChainRequest()
{
    NSMutableArray <MedBaseRequest *> *requestAry;
    NSMutableArray <MedChainReqBlock> *callBackAry;
}
@end

@implementation MedChainRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
