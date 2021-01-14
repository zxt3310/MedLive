//
//  MedLivePatientCell.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/14.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedLivePatientCell.h"

@implementation MedLivePatientCell
{
    UIImageView *headerView;
    UILabel *nameLb;
    UILabel *sexLb;
    UILabel *ageLb;
    UILabel *illLb;
}

- (void)setPatient:(Patient *)patient forIndex:(NSInteger)index{
    nameLb.text = Kstr(patient.name);
    sexLb.text = patient.sex == male ? @"男" : @"女";
    ageLb.text = patient.age == 0?@"不详":[NSString stringWithFormat:@"%ld岁",patient.age];
    illLb.text = patient.symptom;
}
@end
