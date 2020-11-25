//
//  SKLMeetCreateController.m
//  MedLiveAPP
//
//  Created by zxt3310 on 2020/11/4.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLMeetCreateController.h"
#import "SKLMeetCreateViewModel.h"
#import "SKLMeetJoinMeetController.h"
#import <BRDatePickerView.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <LGAlertView/LGAlertView.h>
#import <YYModel.h>

@interface SKLMeetCreateController()<UIDocumentPickerDelegate,TZImagePickerControllerDelegate>

@end
@implementation SKLMeetCreateController
{
    UITextField *titleField;
    BRDatePickerView *datePicker;
    UILabel *startDateLabel;
//    UILabel *endDateLabel;
    UITextField *passwordField;
    UISwitch *enablePasswordSW;
    UISwitch *enableUploadSW;
    UIView *codeView;
    NSString *dateStr;
    
    UIView *filesView; //文档列表
    
    SKLMeetCreateViewModel *viewModel;
    
    NSMutableArray <UIView *>* fileViewAry;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"创建会议";
    viewModel = [[SKLMeetCreateViewModel alloc] init];
    fileViewAry = [NSMutableArray array];
    
    datePicker = [[BRDatePickerView alloc] init];
    datePicker.pickerMode = BRDatePickerModeMDHM;
    datePicker.title = @"开始时间";
    if (@available(iOS 13.0, *)) {
        datePicker.minDate = [NSDate now];
    } else {
        datePicker.minDate = [NSDate date];
    };
    datePicker.showUnitType = BRShowUnitTypeAll;
    
    __weak UILabel *weakLabel = startDateLabel;
    WeakSelf
    datePicker.resultBlock = ^(NSDate* selectDate, NSString* selectValue) {
        weakLabel.text = selectValue;
        [weakSelf pickerDidSelect:selectDate];
    };
    [enablePasswordSW addTarget:self action:@selector(passwordSWDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)pickerDidSelect:(NSDate *)selectDate{
    dateStr = [NSString stringWithFormat:@"%ld-%02zd-%02zd %02zd:%02zd:%02zd",selectDate.br_year,selectDate.br_month,selectDate.br_day,selectDate.br_hour,selectDate.br_minute,selectDate.br_second];
}

- (void)selectStartDate:(UITapGestureRecognizer*)sender{
    datePicker.title = @"选择开始时间";
    [datePicker show];
}

//- (void)selectEndDate:(UITapGestureRecognizer*)sender{
//    datePicker.title = @"选择结束时间";
//    [datePicker show];
//}

- (void)passwordSWDidChange:(UISwitch *)sender{
    codeView.hidden = !sender.on;
}

- (void)selectUploadFile{
    LGAlertView *alertView = [LGAlertView alertViewWithTitle:@"选择来源" message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"图片",@"文件"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    alertView.actionHandler = ^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        switch (index) {
            case 0:
                [self selectImage];
                break;
            case 1:
                [self selectDocument];
                break;
            default:
                break;
        }
    };
    [alertView showAnimated];
}

- (void)selectImage{
    TZImagePickerController *pickControl = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    pickControl.modalPresentationStyle = UIModalPresentationFullScreen;
    pickControl.allowPickingVideo = NO;
    pickControl.allowTakeVideo = NO;
    pickControl.maxImagesCount = 1;
    [self presentViewController:pickControl animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    UIImage *file = [photos firstObject];
    NSString *fileName = [assets.firstObject valueForKey:@"filename"];
    [viewModel uploadPicture:file CompleteBlock:^(NSString *picUrl) {
        
        [self addFileUI:fileName Url:picUrl];
    } fail:^{
        
    }];
}

- (void)addFileUI:(NSString *)fileName Url:(NSString *)url{
    UIView *view = [[UIView alloc] init];
    view.uniTag = url;
    [view enableFlexLayout:YES];
    [view setLayoutAttrStrings:@[
        @"height",@"30",
        @"justifyContent",@"center"
    ]];
    
    UILabel *fileNameLable = [[UILabel alloc] init];
    fileNameLable.text = fileName;
    fileNameLable.font = [UIFont systemFontOfSize:12];
    [fileNameLable enableFlexLayout:YES];
    [view addSubview:fileNameLable];
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn enableFlexLayout:YES];
    [delBtn setTitle:@"—" forState:UIControlStateNormal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:3];
    [delBtn setBackgroundColor:[UIColor redColor]];
    [delBtn setLayoutAttrStrings:@[@"position",@"absolute",@"top",@"6",@"right",@"0",@"width",@"18",@"height",@"18"]];
    [delBtn setViewAttrStrings:@[@"borderRadius",@"9"]];
    [delBtn addTarget:self action:@selector(fileDel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:delBtn];
    
    [fileViewAry addObject:view];
    [filesView addSubview:view];
    [filesView markDirty];
}

- (void)fileDel:(UIButton *)sender{
    UIView *superView = sender.superview;
    [superView removeFromSuperview];
    [fileViewAry removeObject:superView];
    [filesView markDirty];
}

- (void)selectDocument{
    NSArray *types = @[@"public.data",
                       @"com.microsoft.powerpoint.ppt",
                       @"com.microsoft.word.doc",
                       @"com.microsoft.excel.xls",
                       @"com.microsoft.powerpoint.pptx",
                       @"com.microsoft.word.docx",
                       @"com.microsoft.excel.xlsx",
                       @"public.avi",
                       @"public.mpeg-4",
                       @"com.compuserve.gif",
                       @"public.jpeg",
                       @"public.png",
                       @"public.plain-text",
                       @"com.adobe.pdf"];

    UIDocumentPickerViewController *documentVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    documentVC.delegate = self;
    [self presentViewController:documentVC animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    BOOL isAuthored = [urls.firstObject startAccessingSecurityScopedResource];
    if (isAuthored) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        //读取文件
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            
                NSError *error = nil;
                NSString *fileName = [newURL lastPathComponent];
                NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
                
                if (error) {
                    NSLog(@"文件读取出错: %@",error);
                }else{
                    [viewModel uploadFile:fileData Name:fileName FileUrl:newURL success:^(NSString * _Nonnull picUrl) {
                        NSLog(@"上传: %@",fileName);
                        [self addFileUI:fileName Url:picUrl];
                    }];
                    
                }
                [self dismissViewControllerAnimated:YES completion:NULL];
        }];
    }else{
        NSLog(@"无权访问");
    }
    [urls.firstObject stopAccessingSecurityScopedResource];

}

#pragma 创建业务
- (void)createMeetting{
    NSString *titleName = titleField.text;
    NSString *password = passwordField.text;
    NSArray *checkAry = [NSArray arrayWithObjects:titleName,dateStr, nil];
    NSArray *alertAry = @[@"请输入会议主题",@"请选择开始时间"];
    [MedLiveAppUtilies checkForm:checkAry Aleart:alertAry Complate:^(bool success, NSString *alert) {
        if (success) {
           [viewModel createLivePlanWithTitle:titleName
                                          Uid:[AppCommondCenter sharedCenter].currentUser.uid
                                        Start:dateStr
                                     Password:password
                                    allowDocs:enableUploadSW.on
                                         Docs:[self getDocsPathArrayJson]
                                     Complete:^(NSString *channelId, NSString *title, NSString *roomId) {
               
               SKLMeetJoinMeetController *meetJoinVC = [[SKLMeetJoinMeetController alloc] init];
               meetJoinVC.roomId = roomId;
               [self.navigationController pushViewController:meetJoinVC animated:YES];
           }];
        }else{
            NSLog(@"%@",alert);
        }
    }];
}

- (NSString *)getDocsPathArrayJson{
    NSMutableArray <NSString *>*ary = [NSMutableArray array];
    [fileViewAry enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.uniTag) {
            [ary addObject:view.uniTag];
        }
    }];
    return [ary yy_modelToJSONString];
}

- (void)popViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc
{
    
}
@end
