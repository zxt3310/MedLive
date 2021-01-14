//
//  MedLivePatientController.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/14.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedLivePatientController.h"
#import <YYWebImage.h>
#import <YBImageBrowser.h>

@interface MedLivePatientController()<YBImageBrowserDataSource>

@end

@implementation MedLivePatientController
{
    UIImageView *headerView;
    UILabel *nameLb;
    UILabel *sexLb;
    UILabel *ageLb;
    UILabel *illLb;
    UIView *contentView;
    NSArray *urls;
}

@synthesize patient = _patient;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"患者详情";
    urls = [NSArray array];
}

- (void)setPatient:(Patient *)patient{
    _patient = patient;
    [self.view layoutIfNeeded];
    
    nameLb.text = Kstr(patient.name);
    sexLb.text = patient.sex == male ? @"男" : @"女";
    ageLb.text = patient.age == 0?@"不详":[NSString stringWithFormat:@"%ld岁",patient.age];
    illLb.text = patient.symptom;
    
    NSString *urlStrs = patient.resource;
    urls = [MedLiveAppUtilies stringToJsonDic:urlStrs];
    [self setupPic:urls];
}

- (void)setupPic:(NSArray *)urls{
    for (int i=0;i<urls.count;i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView enableFlexLayout:YES];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setLayoutAttrStrings:@[@"width",@"90",@"height",@"90",@"margin",@"10"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        imageView.tag = i + 99;
        imageView.yy_imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Cdn_domain,urls[i]]];
        [contentView addSubview:imageView];
    }
}

- (NSInteger)yb_numberOfCellsInImageBrowser:(YBImageBrowser *)imageBrowser{
    return urls.count;
}

- (id<YBIBDataProtocol>)yb_imageBrowser:(YBImageBrowser *)imageBrowser dataForCellAtIndex:(NSInteger)index{
    NSString *url = [urls objectAtIndex:index];
    YBIBImageData *data = [YBIBImageData new];
    data.projectiveView = [contentView viewWithTag:index + 99];
    data.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Cdn_domain,url]];
    return data;
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentPage = sender.view.tag - 99;
    [browser show];
}

@end
