//
//  CYBaseViewController.h
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

#define kCustomeNaviViewTag 9999
@interface CYBaseViewController : UIViewController
@property (nonatomic, strong) UIView *customNavigationView;
- (void)setRightNaviItemWithTitle:(NSString *)title image:(UIImage *)icon action:(ClickActionBlock) action;
//返回按钮默认箭头，只需配置方法
- (void)setLeftNaviItemAction:(ClickActionBlock) action;

- (void)setMiddleNaviWithTitle:(NSString *)title;

- (void)updateMiddelTitle:(NSString *)title;

- (void)updateRightTitle:(NSString *)title;


@end
