//
//  SKLMeetJoinMeetController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/25.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMeetJoinMeetController.h"
#import "MedLiveRoomInfoRequest.h"
#import "MedLiveRoomMeetting.h"
#import "MedMultipleMeettingController.h"
#import <LGAlertView.h>

@implementation SKLMeetJoinMeetController
{
    UILabel *roomIdLabel;
    UILabel *pwdLabel;
    UILabel *startTimeLabel;
    UILabel *titleLabel;
    UILabel *linkLable;
    
    MedLiveRoomMeetting *room;
    NSString *pwdText;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    MedLiveRoomInfoRequest *request = [[MedLiveRoomInfoRequest alloc] initWithRoomId:self.roomId];
    [request fetchWithComplete:^(__kindof MedLiveRoom *room) {
        MedLiveRoomMeetting *meetRoom = (MedLiveRoomMeetting *)room;
        self->room = meetRoom;
        roomIdLabel.text = meetRoom.roomId;
        pwdLabel.text = KIsBlankString(meetRoom.password)?@"无密码":meetRoom.password;
        startTimeLabel.text = meetRoom.startTime;
        titleLabel.text = meetRoom.roomTitle;
        linkLable.text = [NSString stringWithFormat:@"%@/join/room/meeting/%@",Domain,meetRoom.roomId];
    }];
}

- (void)joinMeet{
    if (KIsBlankString(room.password)) {
        [self pushVC];
    }else{
        LGAlertView *alert = [LGAlertView alertViewWithTextFieldsAndTitle:@"入会密码" message:@"请输入密码" numberOfTextFields:1 textFieldsSetupHandler:^(UITextField *textField, NSUInteger index) {
            textField.textAlignment = NSTextAlignmentCenter;
            [textField addTarget:self action:@selector(pwdDidChange:) forControlEvents:UIControlEventEditingChanged];
        } buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        
        alert.actionHandler = ^(LGAlertView *alertView, NSUInteger index, NSString *title) {
            if (room.password == pwdText) {
                [alertView dismissAnimated];
                [self pushVC];
            }else{
                [self errorPwd:alertView];
            }
        };
        
        alert.cancelHandler = ^(LGAlertView * _Nonnull alertView) {
            [alertView dismissAnimated];
        };
        alert.dismissOnAction = NO;
        [alert showAnimated];
    }
}

- (void)pwdDidChange:(UITextField *)textField{
    pwdText = textField.text;
}

- (void)pushVC{
    MedMultipleMeettingController *meetVC = [[MedMultipleMeettingController alloc] init];
    meetVC.roomId = room.roomId;
    [self.navigationController pushViewController:meetVC animated:YES];
}

- (void)errorPwd:(LGAlertView *)alertView{
    UIView *view = [alertView valueForKey:@"view"];
    NSArray <UIView *> *ary = view.subviews;
    __block NSArray <UIView *>*scrollSubs;
    [ary enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[UIScrollView class]]) {
            scrollSubs = obj.subviews;
            *stop = YES;
        }
    }];
    
    [scrollSubs enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)obj;
            if ([label.text isEqualToString:@"请输入密码"]) {
                label.text = @"密码错误";
                label.textColor = [UIColor redColor];
                *stop = YES;
            }
        }
    }];
}

- (void)dealloc
{
    
}
@end
