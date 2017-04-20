//
//  UYUPrescriptionViewController.m
//  UYUClient
//
//  Created by mac on 17/4/11.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUPrescriptionViewController.h"
#import "UYUPresDetialViewController.h"
#import "UYUPrescriptionCell.h"
#import "UYUHttpHandler.h"
#import "UYUUserInfo.h"
#import "SVProgressHUD.h"
#import "UIView+YSKit.h"
#import "UYUColor.h"
#import "MJRefresh.h"

@interface UYUPrescriptionViewController ()<UITableViewDelegate, UITableViewDataSource, PrescriptionCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSDictionary *presNamesDict;
@property (nonatomic, strong) UIImage *presHeadImage;
@property (nonatomic, strong) UIButton *addPresButton;

@property (nonatomic, copy) NSDictionary *prescriptionDataDict;

@property (nonatomic, strong) NSArray *idleImages;
@property (nonatomic, strong) NSArray *refreshingImages;
@end

@implementation UYUPrescriptionViewController
- (UIButton *)addPresButton
{
    if (_addPresButton == nil) {
        _addPresButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPresButton.backgroundColor = [UYUColor uyuGreenColor];
        _addPresButton.layer.masksToBounds = YES;
        _addPresButton.hidden = YES;
        _addPresButton.titleLabel.font = [UIFont systemFontOfSize:30];
        [_addPresButton setTitle:@"+" forState:UIControlStateNormal];
        [_addPresButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addPresButton addTarget:self action:@selector(addPrecription:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPresButton;
}
- (UIImage *)presHeadImage
{
    if (_presHeadImage == nil) {
        _presHeadImage = [UIImage imageNamed:@"ic_pres_icon"];
    }
    return _presHeadImage;
}
- (NSDictionary *)presNamesDict{
    if (_presNamesDict == nil) {
        _presNamesDict = @{@"stereoscope":@"立体镜",
                          @"fractured_ruler":@"裂隙尺",
                          @"reversal":@"翻转拍",
                          @"red_green_read":@"红绿阅读训练",
                          @"approach":@"推进训练",
                          @"r_g_variable_vector":@"红绿可变训练",
                          @"r_g_fixed_vector":@"红绿固定训练",
                          @"glance":@"扫视",
                          @"follow":@"追随训练"};
    }
    return _presNamesDict;
}



- (NSMutableArray *)dataSourceArr
{
    if (_dataSourceArr == nil) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.rowHeight = kPrescriptionCellHeight;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addPresButton];
    
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    self.addPresButton.frame = CGRectMake(kScreenWidth - AdaptWidth(80), kScreenHeight - AdaptWidth(80), AdaptWidth(64), AdaptWidth(64));
    self.addPresButton.layer.cornerRadius = _addPresButton.height/2.0;
    
    [self addWebViewPullDownRefresh];
    [self loadUserPrescriptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableNotionficatin:) name:kUpdatePrescritionTableNotification object:nil];
    
}

- (void)updateTableNotionficatin:(NSNotification *)noti
{
    [self loadUserPrescriptions];
}
- (NSArray *)idleImages
{
    if (_idleImages == nil) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSUInteger i = 1; i<=60; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
            [images addObject:image];
        }
        
        _idleImages = images;
    }
    return _idleImages;
}


- (NSArray *)refreshingImages
{
    if (_refreshingImages == nil) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
            [images addObject:image];
        }
        _refreshingImages = images;
    }
    return _refreshingImages;
}
- (void)addWebViewPullDownRefresh
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
    [header setImages:self.idleImages forState:MJRefreshStateIdle];
    [header setImages:self.refreshingImages forState:MJRefreshStatePulling];
    [header setImages:self.refreshingImages forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
}
- (void)pullDown
{
    [self.tableView.mj_header endRefreshing];
    [self loadUserPrescriptions];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUserPrescriptions
{
    [SVProgressHUD show];
    [self.dataSourceArr removeAllObjects];
    __weak typeof(self) weakSelf = self;
    
    [[UYUHttpHandler shareInstance] getPrescriptionsWithUserId:[self.uyuUserDict[@"userid"] description]
                                                    needCreate:@"0"
                                                         token:[UYUUserInfo shared].sessionId
                                                       success:^(NSDictionary *responseDictionary) {
                                                           NSString *respCode = [responseDictionary[@"code"] description];
                                                           if ([respCode isEqualToString:@"0"]) {
                                                               if ([responseDictionary[@"data"] isKindOfClass:[NSDictionary class]]) {
                                                                   NSDictionary *dataDict = responseDictionary[@"data"];
                                                                   weakSelf.prescriptionDataDict = dataDict;
                                                                   
                                                                   NSDictionary *trainPresDict = dataDict[@"training_pres_list"];
                                                                   NSString *subcount = trainPresDict[@"subcount"];
                                                                   for (int i = 0; i < [subcount integerValue]; i++) {
                                                                       NSString *key = [NSString stringWithFormat:@"%d", i];
                                                                       [weakSelf.dataSourceArr addObject:trainPresDict[key]];
                                                                   }
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       [SVProgressHUD dismiss];
                                                                       _addPresButton.hidden = NO;
                                                                       [weakSelf.tableView reloadData];
                                                                   });
                                                               }
                                                           }else{
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [SVProgressHUD showErrorWithStatus:responseDictionary[@"message"]];
                                                               });
                                                           }
    } failure:^(NSDictionary *errorDictionary) {
        [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];

    }];
}
#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //去处方详情页面
    NSDictionary *presInfoDict = self.dataSourceArr[indexPath.row];
    
    UYUPresDetialViewController *presDetialVC = [[UYUPresDetialViewController alloc] init];
    presDetialVC.isAddPrescription = NO;
    presDetialVC.allPrescriptioonsDict = self.prescriptionDataDict;
    presDetialVC.currentPresType = presInfoDict[@"train_item_type"];
    presDetialVC.modifyInfoDict = presInfoDict;
    presDetialVC.modifyIndex = indexPath.row;
    
    [presDetialVC setMiddleNaviWithTitle:self.presNamesDict[presInfoDict[@"train_item_type"]]];
    [presDetialVC setLeftNaviItemAction:^(UIButton *obj) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    
    [presDetialVC setRightNaviItemWithTitle:@"处方" image:nil action:^(UIButton *obj) {
        if ([UYUPresNameMenu shared].left < kScreenWidth - 10) {
           [[UYUPresNameMenu shared] hiddenPrescriPtion];
        }else{
            NSString *type = ((UYUPresDetialViewController *)[UYUPresNameMenu shared].delegate).currentPresType;
            [[UYUPresNameMenu shared] showPrescriptionWithCurrentPresType:type];
        }
    }];
    presDetialVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:presDetialVC animated:YES];
    
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"pres_cell";
    UYUPrescriptionCell *cell = (UYUPrescriptionCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UYUPrescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    NSDictionary *presInfo = self.dataSourceArr[indexPath.row];
    [cell handlePrescriptionWithName:[self prescritionNameWithInfo:presInfo]
                           serialNum:[presInfo[@"scheme_process_num"] description]
                           trainTime:[presInfo[@"repeat_training_times"] description]
                             headImg:self.presHeadImage];
    return cell;
}

- (NSString *)prescritionNameWithInfo:(NSDictionary *)info
{
    NSString *key = info[@"train_item_type"];
    NSMutableString *presName = [NSMutableString string];
    if ([key isEqualToString:@"stereoscope"]) {
        [presName appendString:self.presNamesDict[@"stereoscope"]];
        NSString *trainType = [info[@"training_type"] description];
        if([trainType isEqualToString:@"1"]){
            [presName appendString:@"散开"];
        }else if([trainType isEqualToString:@"0"]){
            [presName appendString:@"集合"];
        }
        
    }else if([key isEqualToString:@"fractured_ruler"]){
        [presName appendString:self.presNamesDict[@"fractured_ruler"]];
        NSString *trainType = [info[@"training_type"] description];
        if([trainType isEqualToString:@"1"]){
            [presName appendString:@"散开"];
        }else if([trainType isEqualToString:@"0"]){
            [presName appendString:@"集合"];
        }
        
    }else if([key isEqualToString:@"reversal"]){
        [presName appendString:self.presNamesDict[@"reversal"]];
        NSString *eyeType = [info[@"eye_type"] description];
        if ([eyeType isEqualToString:@"0"]) {
            [presName appendString:@"单眼"];
        }else{
            [presName appendString:@"双眼"];
        }
    }else if([key isEqualToString:@"red_green_read"]){
        [presName appendString:self.presNamesDict[@"red_green_read"]];
        
    }else if([key isEqualToString:@"approach"]){
        [presName appendString:self.presNamesDict[@"approach"]];
        
    }else if([key isEqualToString:@"r_g_variable_vector"]){
        [presName appendString:self.presNamesDict[@"r_g_variable_vector"]];
        NSString *trainType = [info[@"training_type"] description];
        if([trainType isEqualToString:@"1"]){
            [presName appendString:@"散开"];
        }else if([trainType isEqualToString:@"0"]){
            [presName appendString:@"集合"];
        }
        
    }else if([key isEqualToString:@"r_g_fixed_vector"]){
        [presName appendString:self.presNamesDict[@"r_g_fixed_vector"]];
        NSString *trainType = [info[@"training_type"] description];
        if([trainType isEqualToString:@"1"]){
            [presName appendString:@"散开"];
        }else if([trainType isEqualToString:@"0"]){
            [presName appendString:@"集合"];
        }
    }else if([key isEqualToString:@"glance"]){
        [presName appendString:self.presNamesDict[@"glance"]];
        
    }else if([key isEqualToString:@"follow"]){
        [presName appendString:self.presNamesDict[@"follow"]];
        NSString *lineType = [info[@"line_type"] description];
        if ([lineType isEqualToString:@"0"]) {
            [presName appendString:@"直线"];
        }else if ([lineType isEqualToString:@"1"]) {
            [presName appendString:@"曲线"];
        }else if ([lineType isEqualToString:@"2"]) {
            [presName appendString:@"虚线"];
        }
    }
    if (![presName hasSuffix:@"训练"]) {
        [presName appendString:@"训练"];
    }
    return presName;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat kAnimationDuration = 0.8f;
    
    CAGradientLayer *contentLayer = (CAGradientLayer *)self.addPresButton.layer;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = kAnimationDuration;
    scaleAnimation.cumulative = NO;
    scaleAnimation.repeatCount = 1;
    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [contentLayer addAnimation: scaleAnimation forKey:@"myScale"];
}

#pragma mark -
#pragma mark PrescriptionCellDelegate
- (void)prescriptionDeleteWithIndexPath:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"row %ld  section %ld", indexPath.row, indexPath.section);
    if (indexPath.row < [self.dataSourceArr count]) {
        NSMutableDictionary *submitPresDict = [NSMutableDictionary dictionaryWithDictionary:self.prescriptionDataDict];
        NSMutableDictionary *presListDict = nil;
        if (![submitPresDict[@"training_pres_list"] isKindOfClass:[NSMutableDictionary class]]) {
            presListDict = [NSMutableDictionary dictionaryWithDictionary:submitPresDict[@"training_pres_list"]];
        }else{
            presListDict = submitPresDict[@"training_pres_list"];
        }
        __weak typeof(self) weakSelf = self;
        
        
        NSMutableDictionary *tempListDict = [NSMutableDictionary dictionary];
        
        NSInteger subCount = [presListDict[@"subcount"] integerValue];
        if (subCount == 0) {
            return;
        }else{
            subCount = subCount - 1;
            tempListDict[@"subcount"] = [NSString stringWithFormat:@"%ld", subCount];
        }
        NSInteger newIndex = 0;
        for (int i = 0; i < subCount + 1; i++) {
            NSString *oldKey = [NSString stringWithFormat:@"%d", i];
            if (indexPath.row == i) {
                continue;
            }else{
                [tempListDict setValue:presListDict[oldKey] forKey:[NSString stringWithFormat:@"%ld", newIndex]];
                newIndex = newIndex + 1;
            }
        }
        submitPresDict[@"training_pres_list"] = tempListDict;
        
        [[UYUHttpHandler shareInstance] createTrainPresSchemeWithToken:[UYUUserInfo shared].sessionId
                                                             presParam:submitPresDict
                                                               success:^(NSDictionary *responseDictionary) {
                                                                   NSString *code = [responseDictionary[@"code"] description];
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       if ([code isEqualToString:@"0"]) {
                                                                           weakSelf.prescriptionDataDict = submitPresDict;
                                                                           [weakSelf.dataSourceArr removeObjectAtIndex:indexPath.row];
                                                                           [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                           [SVProgressHUD showSuccessWithStatus:@"删除处方成功"];
                                                                       }else{
                                                                           [SVProgressHUD showErrorWithStatus:@"提交失败请稍后重试"];
                                                                       }
                                                                   });
                                                               } failure:^(NSDictionary *errorDictionary) {
                                                                   
                                                               }];
    }
}

- (void)addPrecription:(UIButton *)btn
{
    UYUPresDetialViewController *presDetialVC = [[UYUPresDetialViewController alloc] init];
    presDetialVC.isAddPrescription = YES;
    presDetialVC.allPrescriptioonsDict = self.prescriptionDataDict;
    presDetialVC.currentPresType = @"stereoscope";
    
    
    [presDetialVC setMiddleNaviWithTitle:self.presNamesDict[@"stereoscope"]];
    [presDetialVC setLeftNaviItemAction:^(UIButton *obj) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    __weak typeof(presDetialVC) weakPresDetialVC = presDetialVC;
    [presDetialVC setRightNaviItemWithTitle:@"处方" image:nil action:^(UIButton *obj) {
        [weakPresDetialVC.view endEditing:YES];
        if ([UYUPresNameMenu shared].left < kScreenWidth - 10) {
            [[UYUPresNameMenu shared] hiddenPrescriPtion];
        }else{
            NSString *type = ((UYUPresDetialViewController *)[UYUPresNameMenu shared].delegate).currentPresType;
            [[UYUPresNameMenu shared] showPrescriptionWithCurrentPresType:type];
        }
    }];
    presDetialVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:presDetialVC animated:YES];

}
@end
