//
//  CYBaseViewController.m
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "CYBaseViewController.h"
#import "UYUColor.h"
#import "Macro.h"


@interface CYBaseViewController ()
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) ClickActionBlock leftBlock;
@property (nonatomic, copy) ClickActionBlock rightBlock;

@property (nonatomic, strong) UIImage *leftIcon;
@property (nonatomic, strong) UIImage *rightIcon;

@property (nonatomic, strong) NSString *rightTitle;
@property (nonatomic, strong) NSString *middleTitle;
@end

@implementation CYBaseViewController

- (UIView *)customNavigationView
{
    if (_customNavigationView == nil) {
        _customNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 64)];
        _customNavigationView.backgroundColor = [UYUColor uyuGreenColor];
        _customNavigationView.tag = 9999;
    }
    return _customNavigationView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - AdaptWidth(200))/2.0, 20, AdaptWidth(200), 44)];
        _titleLabel.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(kScreenWidth - AdaptWidth(80), 20, AdaptWidth(80), 44);
        _rightBtn.hidden = YES;
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.hidden = YES;
        _leftBtn.frame = CGRectMake(5, 20, AdaptWidth(50), 44);
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        [_leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    }
    return _leftBtn;
}

- (void)addCustomNavigationBar
{
    [self.view addSubview:self.customNavigationView];
    [self.customNavigationView addSubview:self.leftBtn];
    [self.customNavigationView addSubview:self.rightBtn];
    [self.customNavigationView addSubview:self.titleLabel];
}

- (void)configCustomNavigationBar
{
    if (self.rightTitle) {
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:self.rightTitle forState:UIControlStateNormal];
    }
    if (self.rightBlock) {
        self.rightBtn.hidden = NO;
        [self.rightBtn addBlock:self.rightBlock forEvent:UIControlEventTouchUpInside];
    }
    if (self.leftBlock) {
        self.leftBtn.hidden = NO;
        [self.leftBtn addBlock:self.leftBlock forEvent:UIControlEventTouchUpInside];
    }
    if (self.middleTitle) {
        self.titleLabel.hidden = NO;
        [self.titleLabel setText:self.middleTitle];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addCustomNavigationBar];
    [self configCustomNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setRightNaviItemWithTitle:(NSString *)title image:(UIImage *)icon action:(ClickActionBlock) action
{
    self.rightTitle = title;
    self.rightIcon = icon;
    self.rightBlock = action;
}
- (void)setLeftNaviItemAction:(ClickActionBlock) action
{
    self.leftBlock = action;
}

- (void)setMiddleNaviWithTitle:(NSString *)title
{
    self.middleTitle = title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMiddelTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)updateRightTitle:(NSString *)title
{
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
}


@end
