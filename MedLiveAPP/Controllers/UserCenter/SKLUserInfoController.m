//
//  SKLUserInfoController.m
//  MedLiveAPP
//
//  Created by zxt on 2020/12/14.
//  Copyright © 2020 Zxt. All rights reserved.
//

#import "SKLUserInfoController.h"
#import <YYWebImage.h>
#import <LGAlertView.h>
#import "SKLUserInfoViewModel.h"
#import <TZImagePickerController.h>
#import "CropImageController.h"

@interface SKLUserInfoController()<TZImagePickerControllerDelegate,CropImageDelegate>

@end

@implementation SKLUserInfoController
{
    UIImageView *headerView;
    UILabel *nameLb;
    UILabel *mobileLb;
    
    UILabel *idCardLb;
    UILabel *hospitalLb;
    UILabel *levelLb;
    
    NSString *name;
    SKLUserInfoViewModel *viewModel;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"个人资料";
    viewModel = [[SKLUserInfoViewModel alloc] init];
    
    [self initUserInfo];
}

- (void)initUserInfo{
    [viewModel fetchInfoWithComplete:^(MedLiveUserModel *user) {
        if (!KIsBlankString(user.headerImgUrl)) {
            headerView.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Cdn_domain,user.headerImgUrl]];
        }
        nameLb.text = Kstr(user.userName);
        mobileLb.text = Kstr(user.mobile);
    }];
}

- (void)changeName{
    LGAlertView *alert = [LGAlertView alertViewWithTextFieldsAndTitle:@"修改姓名" message:nil
                                                   numberOfTextFields:1
                                               textFieldsSetupHandler:^(UITextField *textField, NSUInteger index) {
        textField.text = nameLb.text;
        [textField addTarget:self action:@selector(editingName:) forControlEvents:UIControlEventEditingChanged];
    } buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    
    alert.actionHandler = ^(LGAlertView *alertView, NSUInteger index, NSString *title) {
        if (!KIsBlankString(self->name)) {
            nameLb.text = name;
            [viewModel updateInfoWithName:name complete:^{
                [MedLiveAppUtilies showErrorTip:@"名字已更新"];
            }];
        }
    };
    
    [alert showAnimated];
}

- (void)editingName:(UITextField *)sender{
    name = sender.text;
}

- (void)changeHeader{
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    if (photos.count > 0) {
        UIImage *image = [photos firstObject];
        CropImageController *crop = [[CropImageController alloc] initWithImage:image delegate:self];
        [self.navigationController pushViewController:crop animated:YES];
    }
}

- (void)cropImageDidFinishedWithImage:(UIImage *)image{
    headerView.image = image;
    [viewModel uploadHeaderImg:image complete:^{
        NSLog(@"头像修改完成");
    }];
}

- (void)dealloc
{
    NSLog(@"个人资料页面已释放");
}
@end
