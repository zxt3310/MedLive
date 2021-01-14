//
//  MedLiveRoomConsultation.h
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/21.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "MedLiveRoomMeetting.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    male = 1,
    famale = 2,
} SEX;

@interface MedLiveRoomConsultation : MedLiveRoomMeetting
@property NSArray *patients;
@end

@interface Patient : NSObject <YYModel>
@property (nonatomic) NSInteger pId;
@property (nonatomic) NSInteger cId;
@property (nonatomic) NSInteger uId;
@property (nonatomic) NSInteger sex;
@property (nonatomic) SEX age;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *resource;
@property (nonatomic,strong) NSString *symptom;
@property (nonatomic) NSInteger roomId;
@property (nonatomic,strong) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
