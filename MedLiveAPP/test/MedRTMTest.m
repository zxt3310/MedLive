//
//  MedRTMTest.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/18.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedRTMTest.h"
#import "MedChannelMessage.h"
#import "IMChannelManager.h"

@implementation MedRTMTest
{
    UITextField *textField;
    IMChannelManager *manager;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    manager = [[IMChannelManager alloc] initWithId:@"zxt"];
    [manager rtmJoinChannel];
}

- (void)sendMsg{
    MedChannelMessage *msg = [[MedChannelMessage alloc] initWith:@"名字" Pic:@"图片" Context:textField.text];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:msg];
    [manager sendRawMessage:data Completion:^{
        NSLog(@"消息发送成功");
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [manager leaveChannel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
