//
//  SKLLiveCreateController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/2.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLLiveCreateController.h"
#import <BRPickerView/BRPickerView.h>
#import "SKLLiveCreateViewModel.h"
#import "MedLiveController.h"
#import <TZImagePickerController/TZImagePickerController.h>

@interface SKLLiveCreateController ()<TZImagePickerControllerDelegate>
{
    UITextField *titleField;
    UILabel *dateLabel;
    UITextView *introField;
    BRDatePickerView *datePicker;
    SKLLiveCreateViewModel *viewModel;
    NSString *dateStr;
    UIView *introPicView;
    UIView *coverPicView;
    TZImagePickerController *pickControl;
}
@end

@implementation SKLLiveCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewModel = [[SKLLiveCreateViewModel alloc] init];
    pickControl = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    pickControl.modalPresentationStyle = UIModalPresentationFullScreen;
    pickControl.allowPickingVideo = NO;
    pickControl.allowTakeVideo = NO;
    
    datePicker = [[BRDatePickerView alloc] init];
    datePicker.pickerMode = BRDatePickerModeMDHM;
    datePicker.title = @"选择开播时间";
    datePicker.minDate = [NSDate now];
    datePicker.showUnitType = BRShowUnitTypeAll;
    
    __weak UILabel *weakLabel = dateLabel;
    WeakSelf
    datePicker.resultBlock = ^(NSDate* selectDate, NSString* selectValue) {
        weakLabel.text = selectValue;
        [weakSelf pickerDidSelect:selectDate];
    };
    
    titleField.uniTag = @"liveTitle";
}

- (void)pickerDidSelect:(NSDate *)selectDate{
    dateStr = [NSString stringWithFormat:@"%ld-%02zd-%02zd %02zd:%02zd:%02zd",selectDate.br_year,selectDate.br_month,selectDate.br_day,selectDate.br_hour,selectDate.br_minute,selectDate.br_second];
}

- (void)selectDate{
    [datePicker show];
}

- (void)createPlanWithComplate:(void(^)(NSString *channelId, NSString *title, NSString *roomId)) completeBlock{
    NSArray *formAry = [NSArray arrayWithObjects:titleField.text,dateStr, nil];
    NSArray *alertAry = [NSArray arrayWithObjects:@"直播主题未填写",@"开播时间未选择", nil];
    [MedLiveAppUtilies checkForm:formAry Aleart:alertAry Complate:^(BOOL res, NSString * alertStr) {
        if (res) {
            [self->viewModel createLivePlanWithTitle:self->titleField.text
                                                Desc:self->introField.text
                                                 Uid:[AppCommondCenter sharedCenter].currentUser.uid
                                               Start:self->dateStr
                                              picUrl:@"www.baidu.com"
                                            Complete:^(NSString *channelId, NSString *title, NSString *roomId) {
                if(completeBlock){
                    completeBlock(channelId,title,roomId);
                }else{
                    NSLog(@"创建成功,频道号：%@， 标题：%@， 房间号%@",channelId,title,roomId);
                }
            }];
        }else{
            NSLog(@"%@",alertStr);
        }
    }];
}

- (void)onlyCreate{
    [self createPlanWithComplate:nil];
}

- (void)liveDirectly{
    [self createPlanWithComplate:^(NSString *channelId, NSString *title, NSString *roomId) {
        MedLiveController *liveController = [[MedLiveController alloc] init];
        liveController.channelId = channelId;
        liveController.titleName = title;
        liveController.roomId = roomId;
        [self.navigationController pushViewController:liveController animated:YES];
    }];
}

- (void)selectIntoPics{
    pickControl.maxImagesCount = 5;
    [self presentViewController:pickControl animated:YES completion:nil];
}

- (void)selectCoverPic{
    pickControl.maxImagesCount = 1;
    [self presentViewController:pickControl animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
}

- (void)dealloc
{
    
}
@end
