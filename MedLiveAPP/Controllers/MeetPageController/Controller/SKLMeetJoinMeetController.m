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
#import "MedLiveRoomConsultation.h"
#import "MedMultipleMeettingController.h"
#import "IMManager.h"
#import <LGAlertView.h>

@implementation SKLMeetJoinMeetController
{
    UILabel *roomIdLabel;
    UILabel *pwdLabel;
    UILabel *startTimeLabel;
    UILabel *titleLabel;
    UILabel *linkLable;
    UILabel *welcomLabel;
    
    NSString *pwdText;
    FlexTouchView *joinBtn;
}
@synthesize room = _room;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"概述";
    if (self.roomId) {
        MedLiveRoomInfoRequest *request = [[MedLiveRoomInfoRequest alloc] initWithRoomId:self.roomId];
        [request fetchWithComplete:^(__kindof MedLiveRoom *room) {
            if (![room isMemberOfClass:[MedLiveRoomMeetting class]] && ![room isMemberOfClass:[MedLiveRoomConsultation class]]) {
                joinBtn.userInteractionEnabled = NO;

                [MedLiveAppUtilies showErrorTip:@"无效的房间号"];
                return;
            }
            MedLiveRoomMeetting *meetRoom = (MedLiveRoomMeetting *)room;
            self.room = meetRoom;
        }];
    }
}

- (void)setRoom:(MedLiveRoomMeetting *)room{
    _room = room;
    [self.view layoutIfNeeded];
    
    MedLiveRoomMeetting *meetRoom = (MedLiveRoomMeetting *)room;
    roomIdLabel.text = meetRoom.roomId;
    pwdLabel.text = KIsBlankString(meetRoom.password)?@"无密码":meetRoom.password;
    startTimeLabel.text = meetRoom.startTime;
    titleLabel.text = meetRoom.roomTitle;
    linkLable.text = [NSString stringWithFormat:@"%@/join/room/meeting/%@",Domain_HTTPS,meetRoom.roomId];
    
    [[IMManager sharedManager] getUserAttributeWithId:room.owner Suc:^(NSString *name, NSString *picUrl) {
        if (!KIsBlankString(name)) {
            welcomLabel.hidden = NO;
            welcomLabel.text = [NSString stringWithFormat:@"%@ 邀请您参加会议",name];
        }
    }];
}

- (void)joinMeet{
    if([MedLiveAppUtilies needLogin]){
        return;
    }
    
    if (KIsBlankString(self.room.password)) {
        [self pushVC];
    }else{
        LGAlertView *alert = [LGAlertView alertViewWithTextFieldsAndTitle:@"入会密码" message:@"请输入密码" numberOfTextFields:1 textFieldsSetupHandler:^(UITextField *textField, NSUInteger index) {
            textField.textAlignment = NSTextAlignmentCenter;
            [textField addTarget:self action:@selector(pwdDidChange:) forControlEvents:UIControlEventEditingChanged];
        } buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        
        alert.actionHandler = ^(LGAlertView *alertView, NSUInteger index, NSString *title) {
            if (self.room.password == pwdText) {
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
//复制会议号
- (void)pasteRoomid{
    UIPasteboard *pd = [UIPasteboard generalPasteboard];
    pd.string = [NSString stringWithFormat:@"会议号：%@",self.room.roomId];
    [MedLiveAppUtilies showErrorTip:@"已复制到剪切板"];
}
//复制链接
- (void)pasteLink{
    UIPasteboard *pd = [UIPasteboard generalPasteboard];
    pd.string = [NSString stringWithFormat:@"参会链接：%@",linkLable.text];
    [MedLiveAppUtilies showErrorTip:@"已复制到剪切板"];
}

- (void)shareMeet{
    UIPasteboard *pd = [UIPasteboard generalPasteboard];
    [pd setStrings:@[
        [NSString stringWithFormat:@"会议主题：%@",self.room.roomTitle],
        [NSString stringWithFormat:@"会议时间：%@",self.room.startTime],
        [NSString stringWithFormat:@"%@/join/room/meeting/%@",Domain_HTTPS,self.room.roomId],
        [NSString stringWithFormat:@"会议号：%@",self.room.roomId],
        KIsBlankString(self.room.password)?@"无密码":[NSString stringWithFormat:@"会议密码：%@",self.room.password]
    ]];
    [MedLiveAppUtilies showErrorTip:@"已复制到剪切板"];
}

- (void)pushVC{
    MedMultipleMeettingController *meetVC = [[MedMultipleMeettingController alloc] init];
    meetVC.roomId = self.room.roomId;
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
