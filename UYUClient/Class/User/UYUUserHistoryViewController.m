//
//  UYUUserHistoryViewController.m
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUUserHistoryViewController.h"
#import "Macro.h"
#import "UYUHttpHandler.h"
#import "UYUUserInfo.h"
#import "UYUConsumerCell.h"
#import "SVProgressHUD.h"
#import "UYUPrescriptionViewController.h"
#import "MJRefresh.h"



@interface UYUUserHistoryViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allDays;
@property (nonatomic, strong) NSMutableDictionary *yyyyMdToArrDict;
@property (nonatomic, strong) UIImage *headImage;

@property (nonatomic, strong) NSDictionary *selectedUserDict;

@property (nonatomic, strong) NSArray *idleImages;
@property (nonatomic, strong) NSArray *refreshingImages;
@end

@implementation UYUUserHistoryViewController
- (UIImage *)headImage
{
    if (_headImage == nil) {
        _headImage = [UIImage imageNamed:@"ic_consumer"];
    }
    return _headImage;
}
- (NSMutableArray *)allDays
{
    if (_allDays == nil) {
        _allDays = [[NSMutableArray alloc] init];
    }
    return _allDays;
}

- (NSMutableDictionary *)yyyyMdToArrDict
{
    if (_yyyyMdToArrDict == nil) {
        _yyyyMdToArrDict = [NSMutableDictionary dictionary];
    }
    return _yyyyMdToArrDict;
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
        _tableView.rowHeight = kConsumerCellHeight;
    }
    return _tableView;
}

- (void)addSubviews
{
    [self.view addSubview:self.tableView];
    
}
- (void)layoutSubviews{
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    [self layoutSubviews];
    
    
    [self addWebViewPullDownRefresh];
    
    [self loadAllUser];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark data
- (void)loadAllUser{
    
    [SVProgressHUD show];
    
    [self.allDays removeAllObjects];
    [self.yyyyMdToArrDict removeAllObjects];
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    
    [[UYUHttpHandler shareInstance] cdAllConsumerStoreUserId:[UYUUserInfo shared].storeId
                                                    seUserId:[UYUUserInfo shared].storeId
                                                     success:^(NSDictionary *responseDictionary) {
                                                         if ([responseDictionary[@"respcd"] isEqualToString:@"0000"]) {
                                                             NSArray *dataArr = responseDictionary[@"data"][@"info"];
                                                             if ([dataArr count] > 0) {
                                                                 NSString *lastestDate = dataArr[0][@"create_time"];
                                                                 
                                                                 NSString *day = [lastestDate substringWithRange:NSMakeRange(0, 10)];
                                                                 NSMutableArray *tempArr = [NSMutableArray array];
                                                                 for (int i = 0; i < [dataArr count]; i++) {
                                                                     NSDictionary *infoDict = dataArr[i];
                                                                     NSString *createDate = infoDict[@"create_time"];
                                                                     if ([createDate hasPrefix:day]) {
                                                                         [tempArr addObject:infoDict];
                                                                     }else{//不是同一天的，先把前一天的保存起来，在开始新的一天
                                                                         [weakSelf.allDays addObject:day];
                                                                         [weakSelf.yyyyMdToArrDict setObject:tempArr forKey:day];
                                                                         
                                                                         day = [createDate substringWithRange:NSMakeRange(0, 10)];
                                                                         tempArr = [NSMutableArray array];
                                                                         [tempArr addObject:infoDict];
                                                                     }
                                                                 }
                                                                 //最后一天是不会进for循环的插入的，所以补充插入数据
                                                                 if ([tempArr count] > 0) {
                                                                     [weakSelf.allDays addObject:day];
                                                                     [weakSelf.yyyyMdToArrDict setObject:tempArr forKey:day];
                                                                 }
                                                             }else{
#warning 对没有数据的处理
                                                             }
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [SVProgressHUD dismiss];
                                                                 [weakSelf.tableView reloadData];
                                                             });
                                                         }else{
                                                             [SVProgressHUD showErrorWithStatus:responseDictionary[@"respmsg"]];
                                                         }
    } failure:^(NSDictionary *errorDictionary) {
        [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];
    }];
//    [[UYUHttpHandler shareInstance] nearAllConsumer:[UYUUserInfo shared].sessionId
//                                             userId:[UYUUserInfo shared].uyuOldUserId
//                                            success:^(NSDictionary *responseDictionary) {
//                                                NSString *respCode = [responseDictionary[@"code"] description];
//                                                if ([respCode isEqualToString:@"0"]) {
//                                                    NSArray *dataArr = responseDictionary[@"data"];
//                                                    if ([dataArr count] > 0) {
//                                                        NSString *lastestDate = dataArr[0][@"created_at"];
//                                                        
//                                                        NSString *day = [lastestDate substringWithRange:NSMakeRange(0, 10)];
//                                                        NSMutableArray *tempArr = [NSMutableArray array];
//                                                        for (int i = 0; i < [dataArr count]; i++) {
//                                                            NSDictionary *infoDict = dataArr[i];
//                                                            NSString *createDate = infoDict[@"created_at"];
//                                                            if ([createDate hasPrefix:day]) {
//                                                                [tempArr addObject:infoDict];
//                                                            }else{//不是同一天的，先把前一天的保存起来，在开始新的一天
//                                                                [weakSelf.allDays addObject:day];
//                                                                [weakSelf.yyyyMdToArrDict setObject:tempArr forKey:day];
//                                                                
//                                                                day = [createDate substringWithRange:NSMakeRange(0, 10)];
//                                                                tempArr = [NSMutableArray array];
//                                                                [tempArr addObject:infoDict];
//                                                            }
//                                                        }
//                                                        //最后一天是不会进for循环的插入的，所以补充插入数据
//                                                        if ([tempArr count] > 0) {
//                                                            [weakSelf.allDays addObject:day];
//                                                            [weakSelf.yyyyMdToArrDict setObject:tempArr forKey:day];
//                                                        }
//                                                    }else{
//#warning 对没有数据的处理
//                                                    }
//                                                    
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                        [SVProgressHUD dismiss];
//                                                        [weakSelf.tableView reloadData];
//                                                    });
//                                                }else{
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                        [SVProgressHUD showErrorWithStatus:responseDictionary[@"message"]];
//                                                    });
//                                                }
//                                                
//    } failure:^(NSDictionary *errorDictionary) {
//        [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];
//    }];
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
    
    [self performSelector:@selector(reloadAllUserData) withObject:nil afterDelay:1];
   
}
- (void)reloadAllUserData
{
    dispatch_async(dispatch_get_main_queue(), ^{
         [self loadAllUser];
    });
}
#pragma mark -
#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headId = @"head";
    UITableViewHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
    if (head == nil) {
        head = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headId];
    }
    head.textLabel.text = self.allDays[section];
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AdaptWidth(40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *day = self.allDays[indexPath.section];
    self.selectedUserDict = self.yyyyMdToArrDict[day][indexPath.row];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"训练记录" otherButtonTitles:@"处方", @"手动训练", @"检查录入", nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.yyyyMdToArrDict[self.allDays[section]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"user_cell";
    UYUConsumerCell *cell = (UYUConsumerCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UYUConsumerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *day = self.allDays[indexPath.section];
    NSDictionary *infoDict = self.yyyyMdToArrDict[day][indexPath.row];
//    NSString *type = [[infoDict[@"recept_step"] description] isEqualToString:@"1"] ? @"训练" : @"检查";
    [cell handleCellWithName:infoDict[@"username"] createDate:infoDict[@"create_time"] type:nil headeImage:self.headImage];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.allDays count];
}
#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://训练
        {
            
        }
            break;
        
        case 1://修改处方
        {
            UYUPrescriptionViewController *presVC = [[UYUPrescriptionViewController alloc] init];
            presVC.uyuUserDict = self.selectedUserDict;
            [presVC setMiddleNaviWithTitle:@"修改处方"];
            [presVC setLeftNaviItemAction:^(UIButton *obj) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            presVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:presVC animated:YES];
        }
            break;
        case 2://检查
        {
            
        }
            break;
        default:
            break;
    }
}
@end
