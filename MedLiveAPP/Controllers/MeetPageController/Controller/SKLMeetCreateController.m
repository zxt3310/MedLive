//
//  SKLMeetCreateController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMeetCreateController.h"
#import <BRDatePickerView.h>

@implementation SKLMeetCreateController
{
    UITextField *titleField;
    BRDatePickerView *datePicker;
    UILabel *startDateLabel;
    UILabel *endDateLabel;
    UILabel *passwordLabel;
    UISwitch *enablePasswordSW;
    UISwitch *enableUploadSW;
    UIView *codeView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    datePicker = [[BRDatePickerView alloc] init];
    datePicker.pickerMode = BRDatePickerModeMDHM;
    datePicker.title = @"开始时间";
    datePicker.minDate = [NSDate now];
    datePicker.showUnitType = BRShowUnitTypeAll;
    datePicker.resultBlock = ^(NSDate* selectDate, NSString* selectValue) {
        
        
    };
    [enablePasswordSW addTarget:self action:@selector(passwordSWDidChange:) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)selectStartDate:(UITapGestureRecognizer*)sender{
    datePicker.title = @"选择开始时间";
    [datePicker show];
}

- (void)selectEndDate:(UITapGestureRecognizer*)sender{
    datePicker.title = @"选择结束时间";
    [datePicker show];
}

- (void)passwordSWDidChange:(UISwitch *)sender{
    codeView.hidden = !sender.on;
}
@end
