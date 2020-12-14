//
//  SampleHandler.m
//  MedLiveAPP-Broadcast
//
//  Created by zxt3310 on 2020/11/16.
//  Copyright © 2020 Zxt. All rights reserved.
//


#import "SampleHandler.h"

@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    NSLog(@"开始录屏");
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    NSLog(@"结束录屏");
}

// objective-c
- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            //[agoraUpload sendVideoBuffer:sampleBuffer];
             NSLog(@"RPSampleBufferTypeVideo App~~~~");
            break;
        case RPSampleBufferTypeAudioApp:
            //[agoraUpload sendAudioAppBuffer:sampleBuffer];
            NSLog(@"RPSampleBufferTypeAudio App+++");
            break;
        case RPSampleBufferTypeAudioMic:
            //[agoraUpload sendMicAppBuffer:sampleBuffer];
            break;
        }
    });
}

@end
