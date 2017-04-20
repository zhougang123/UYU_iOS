//
//  UYUPresDetialViewController.h
//  UYUClient
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "CYBaseViewController.h"
#import "UYUPresNameMenu.h"
#import "UYUPresNameMenu.h"

#define kUpdatePrescritionTableNotification @"kUpdatePrescritionTableNotification"


@interface UYUPresDetialViewController : CYBaseViewController

@property (nonatomic, assign) BOOL isAddPrescription;//默认是添加模式为YES  修改模式为NO
@property (nonatomic, strong) NSString *currentPresType;//默认是立体镜处方

@property (nonatomic, strong) NSDictionary *allPrescriptioonsDict;
@property (nonatomic, strong) NSDictionary *modifyInfoDict;//修改模式下需要预先配置处方信息
@property (nonatomic, assign) NSInteger modifyIndex;//要修改处方的索引号

@end
