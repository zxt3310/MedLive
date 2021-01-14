//
//  MedLivePatientCell.h
//  MedLiveAPP
//
//  Created by zxt on 2021/1/14.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedLiveRoomConsultation.h"

@interface MedLivePatientCell : FlexBaseTableCell

- (void)setPatient:(Patient *)patient forIndex:(NSInteger)index;

@end


