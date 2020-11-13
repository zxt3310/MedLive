//
//  MutipleMeettingViewModel.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/12.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MutipleMeettingViewModel.h"
#import "LiveManager.h"

@interface MutipleMeettingViewModel()<LiveManagerRemoteCanvasProvideDelegate>
@property LiveManager *manager;
@end

@implementation MutipleMeettingViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[LiveManager alloc] init];
        _manager.provideDelegate = self;
        [_manager settingEnvtype:MedLiveTypeMeetting];
        _manager.role = AgoraClientRoleBroadcaster;
    }
    return self;
}

- (int)joinMeetting:(NSString *)channelId Token:(NSString *)token{
    NSString *uid;
#ifdef TESTCODE
    channelId = @"MultiRoom";
    token = @"006269ff1d0fecd46b783132c2bda90fc66IACYA7froU9Dy0gY33WaygAcSwZdkh01oCg9va4F9mstp8kyCpYAAAAAEABVr+ww73uvXwEAAQDve69f";
    uid = @"0";
#else
    uid = [AppCommondCenter sharedCenter].currentUser.uid;
#endif
    return [self.manager joinRoomByToken:token
                                   Room:channelId
                                    Uid:uid];
}


- (void)setupLocalView:(__kindof UIView *)localView{
    [self.manager setupVideoLocalView:localView];
    [self.manager enableVideo];
}

- (void)setupRemoteView:(__kindof UIView*)remoteView{
    [self.manager setupVideoRemoteView:remoteView];
}

#pragma viewModel delegate imp
- (void)didAddRemoteMember:(NSUInteger)uid{
    if (self.meettingDelegate) {
        [self.meettingDelegate meetingDidJoinMember:uid];
    }
}
- (void)didRemoteLeave:(NSInteger) uid{
    if (self.meettingDelegate) {
        [self.meettingDelegate meetingDidLeaveMember:uid];
    }
}

- (void)stopLive{
    [self.manager leaveRoom];
}
@end
