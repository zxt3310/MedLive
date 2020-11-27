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
    NSString *coverPicUrl;
    NSMutableArray <UIView*> *introPicsMutable;
}
@end

@implementation SKLLiveCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建直播";
    
    viewModel = [[SKLLiveCreateViewModel alloc] init];
    
    datePicker = [[BRDatePickerView alloc] init];
    datePicker.pickerMode = BRDatePickerModeMDHM;
    datePicker.title = @"选择开播时间";
    if (@available(iOS 13.0, *)) {
        datePicker.minDate = [NSDate now];
    } else {
        datePicker.minDate = [NSDate date];
    }
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
    [self.view endEditing:YES];
}

- (void)createPlanWithComplate:(void(^)(NSString *channelId, NSString *title, NSString *roomId)) completeBlock{
    NSArray *formAry = [NSArray arrayWithObjects:titleField.text,dateStr,coverPicUrl, nil];
    NSArray *alertAry = [NSArray arrayWithObjects:@"直播主题未填写",@"开播时间未选择",@"封面未设置", nil];
    NSMutableArray <NSString*>* picAry = [NSMutableArray array];
    for (UIView *view in introPicsMutable) {
        if (view.uniTag) {
            [picAry addObject:view.uniTag];
        }
    }
    
    [MedLiveAppUtilies checkForm:formAry Aleart:alertAry Complate:^(BOOL res, NSString * alertStr) {
        if (res) {
            [self->viewModel createLivePlanWithTitle:self->titleField.text
                                                Desc:self->introField.text
                                                 Uid:[AppCommondCenter sharedCenter].currentUser.uid
                                               Start:self->dateStr
                                              picUrl:coverPicUrl
                                           introPics:[picAry copy]
                                            Complete:^(NSString *channelId, NSString *title, NSString *roomId) {
                if(completeBlock){
                    completeBlock(channelId,title,roomId);
                }else{
                    NSLog(@"创建成功,频道号：%@， 标题：%@， 房间号%@",channelId,title,roomId);
                    [MedLiveAppUtilies showErrorTip:@"创建成功"];
                }
            }];
        }else{
            NSLog(@"%@",alertStr);
            [MedLiveAppUtilies showErrorTip:alertStr];
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
    if(introPicsMutable.count == 5){
        NSLog(@"图片数量达上限");
        [MedLiveAppUtilies showErrorTip:@"最多5张图片"];
        return;
    }
    TZImagePickerController *pickControl = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    pickControl.modalPresentationStyle = UIModalPresentationFullScreen;
    pickControl.allowPickingVideo = NO;
    pickControl.allowTakeVideo = NO;
    pickControl.maxImagesCount = 5 - introPicsMutable.count;
    [self presentViewController:pickControl animated:YES completion:nil];
}

- (void)selectCoverPic{
    TZImagePickerController *pickControl = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    pickControl.modalPresentationStyle = UIModalPresentationFullScreen;
    pickControl.allowPickingVideo = NO;
    pickControl.allowTakeVideo = NO;
    pickControl.maxImagesCount = 1;
    [self presentViewController:pickControl animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    if (picker.maxImagesCount == 1) {
        [self uploadAndFillcoverPick:[photos firstObject]];
    }else{
        [self upladAndFillIntroPics:photos];
    }
}

- (void)uploadAndFillcoverPick:(UIImage *)pic{
    static UIImageView *coverImg;
    if (!coverImg) {
        coverImg = [[UIImageView alloc] init];
    }
    [viewModel uploadPicture:pic CompleteBlock:^(NSString *picUrl){
        coverPicUrl = picUrl;
        coverImg.image = pic;
        coverImg.contentMode = UIViewContentModeScaleAspectFit;
        [coverImg enableFlexLayout:YES];
        [coverImg setLayoutAttrStrings:@[@"height",@"120",@"width",@"200",@"alignSelf",@"center",@"marginBottom",@"10"]];
        [coverPicView addSubview:coverImg];
        [coverPicView markDirty];
    } fail:^{
        NSLog(@"封面图上传失败");
        [MedLiveAppUtilies showErrorTip:@"上传失败"];
    }];
}

- (void)upladAndFillIntroPics:(NSArray<UIImage*>*)photos{
    if (!introPicsMutable) {
        introPicsMutable = [NSMutableArray array];
    }
    [viewModel uploadPictures:photos success:^(NSString *url,UIImage *img) {
        UIView *picView = [[UIView alloc] init];
        [picView enableFlexLayout:YES];
        [picView setLayoutAttrStrings:@[@"padding",@"8"]];
        //用unitag 存储图片地址
        picView.uniTag = url;
        
        UIImageView *introImg = [[UIImageView alloc] init];
        introImg.image = img;
        introImg.contentMode = UIViewContentModeScaleAspectFill;
        introImg.clipsToBounds = YES;
        [introImg enableFlexLayout:YES];
        [introImg setLayoutAttrStrings:@[@"height",@"100",@"width",@"100"]];
        [picView addSubview:introImg];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn enableFlexLayout:YES];
        [delBtn setTitle:@"—" forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:3];
        [delBtn setBackgroundColor:[UIColor redColor]];
        [delBtn setLayoutAttrStrings:@[@"position",@"absolute",@"top",@"0",@"right",@"0",@"width",@"18",@"height",@"18"]];
        [delBtn setViewAttrStrings:@[@"borderRadius",@"9"]];
        [delBtn addTarget:self action:@selector(introPicDel:) forControlEvents:UIControlEventTouchUpInside];
        [picView addSubview:delBtn];
        
        [introPicView addSubview:picView];
        [introPicView markDirty];
        [introPicsMutable addObject:picView];
    } fail:^{
        
    } finaly:^(int suc, int failure) {
        NSLog(@"成功上传 %d张, 失败 %d张",suc,failure);
        [MedLiveAppUtilies showErrorTip:[NSString stringWithFormat:@"成功上传 %d张, 失败 %d张",suc,failure]];
    }];
}

- (void)introPicDel:(UIButton *)sender{
    UIView *superView = sender.superview;
    [introPicsMutable removeObject:superView];
    [superView removeFromSuperview];
    [introPicView markDirty];
}


- (void)dealloc
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end
