//
//  UYUPresNameMenu.m
//  UYUClient
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUPresNameMenu.h"
#import "Macro.h"
#import "UIView+YSKit.h"
#import "AppDelegate.h"

@interface UYUPresNameMenu ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *presNameArr;
@property (nonatomic, strong) NSDictionary *presNamesDict;


@end

@implementation UYUPresNameMenu

+ (instancetype)shared
{
    static UYUPresNameMenu *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithFrame:CGRectMake(kScreenWidth, 64, AdaptWidth(180), kScreenHeight - 64)];
        [shareAppDelegate.window addSubview:_instance];

    });
    return _instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        self.backgroundColor = UIColorFromRGB(0xD1F1FD);
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    return self;
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
        _tableView.rowHeight = AdaptWidth(44);
        _tableView.backgroundColor = UIColorFromRGB(0xD1F1FD);
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    return _tableView;
}

- (NSArray *)presNameArr
{
    if (_presNameArr == nil) {
        _presNameArr = @[@"立体镜处方",
                         @"裂隙尺处方",
                         @"翻转拍处方",
                         @"红绿阅读训练处方",
                         @"推进训练处方",
                         @"红绿可变训练处方",
                         @"红绿固定训练处方",
                         @"扫视处方",
                         @"追随训练处方"];
    }
    return _presNameArr;
}
- (NSDictionary *)presNamesDict{
    if (_presNamesDict == nil) {
        _presNamesDict = @{@"立体镜处方":@"stereoscope",
                           @"裂隙尺处方":@"fractured_ruler",
                           @"翻转拍处方":@"reversal",
                           @"红绿阅读训练处方":@"red_green_read",
                           @"推进训练处方":@"approach",
                           @"红绿可变训练处方":@"r_g_variable_vector",
                           @"红绿固定训练处方":@"r_g_fixed_vector",
                           @"扫视处方":@"glance",
                           @"追随训练处方":@"follow"};
    }
    return _presNamesDict;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.presNameArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"presNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = UIColorFromRGB(0xD1F1FD);
    }
    NSString *name = self.presNameArr[indexPath.row];
    
    if ([self.presNamesDict[name] isEqualToString:self.selectType]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectPrescritionType:)]) {
        self.selectType = self.presNamesDict[self.presNameArr[indexPath.row]];
        [self.delegate selectPrescritionType:self.presNamesDict[self.presNameArr[indexPath.row]]];
        [self hiddenPrescriPtion];
    }
}

- (void)showPrescriptionWithCurrentPresType:(NSString *)type
{
    self.selectType = type;
    dispatch_async(dispatch_get_main_queue(), ^{
        [shareAppDelegate.window bringSubviewToFront:[UYUPresNameMenu shared]];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(kScreenWidth - self.width, self.top, self.width, self.height);
        }];
    });
    
}
- (void)hiddenPrescriPtion
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(kScreenWidth, self.top, self.width, self.height);
    }];
}
@end
