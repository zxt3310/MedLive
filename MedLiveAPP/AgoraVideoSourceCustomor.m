//
//  AgoraVideoSourceCustomor.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/16.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "AgoraVideoSourceCustomor.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

@interface AgoraVideoSourceCustomor()<AgoraVideoSourceProtocol>

@end

@implementation AgoraVideoSourceCustomor

- (BOOL)shouldInitialize{
    return YES;
}

- (void)shouldStart{
    
}

- (void)shouldStop{
    
}

- (void)shouldDispose{
    
}

- (AgoraVideoBufferType)bufferType{
    return AgoraVideoBufferTypeRawData;
}

- (AgoraVideoCaptureType)captureType{
    return AgoraVideoCaptureTypeScreen;
}

- (AgoraVideoContentHint)contentHint{
    return AgoraVideoContentHintNone;
}

@end
