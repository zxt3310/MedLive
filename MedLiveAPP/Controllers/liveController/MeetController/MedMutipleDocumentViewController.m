//
//  MedMutipleDocumentViewController.m
//  MedLiveAPP
//
//  Created by zxt on 2021/1/19.
//  Copyright © 2021 Zxt. All rights reserved.
//

#import "MedMutipleDocumentViewController.h"
#import "MedLiveWebContoller.h"

@interface MedMutipleDocumentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MedMutipleDocumentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会议文档";
    
    UITableView *DocumentTable = [[UITableView alloc] init];
    DocumentTable.delegate = self;
    DocumentTable.dataSource = self;
    DocumentTable.rowHeight = UITableViewAutomaticDimension;
    DocumentTable.tableHeaderView = [UIView new];
    DocumentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.layoutView addSubview:DocumentTable];
    
    [DocumentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.layoutView);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.documentUrls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *str = self.documentUrls[indexPath.item];
    NSArray *pathAry = [str componentsSeparatedByString:@"/"];
    NSString *fileName = [pathAry lastObject];
    cell.textLabel.text = fileName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MedLiveWebContoller *webVC = [[MedLiveWebContoller alloc] init];
    webVC.urlStr = [NSString stringWithFormat:@"%@%@",Cdn_domain,self.documentUrls[indexPath.item]];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
