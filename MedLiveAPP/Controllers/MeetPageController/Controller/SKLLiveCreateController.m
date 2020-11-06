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

@interface SKLLiveCreateController ()
{
    UITextField *titleField;
    UILabel *dateLabel;
    UITextView *introField;
    BRDatePickerView *datePicker;
    NSString *dateStr;
    NSDate *startDate;
}
@end

@implementation SKLLiveCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datePicker = [[BRDatePickerView alloc] init];
    datePicker.pickerMode = BRDatePickerModeMDHM;
    datePicker.title = @"选择开播时间";
    datePicker.minDate = [NSDate now];
    datePicker.showUnitType = BRShowUnitTypeAll;
    
    __weak UILabel *weakLabel = dateLabel;
    datePicker.resultBlock = ^(NSDate* selectDate, NSString* selectValue) {
        self->startDate = selectDate;
        weakLabel.text = selectValue;
    };
    
    titleField.uniTag = @"liveTitle";
    introField.text = @"liveIntro";
    
}

- (void)selectDate{
    [datePicker show];
}

- (void)createPlan{
    
}

- (void)liveDirectly{
    
}
@end
