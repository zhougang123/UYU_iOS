//
//  UYUCreateViewController.m
//  UYUClient
//
//  Created by mac on 17/4/11.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUCreateViewController.h"
#import "Macro.h"
#import "UIView+YSKit.h"
#import "UIButton+ButtonStyle.h"
#import "UYUColor.h"
#import "UYUCheckBox.h"
#import "SVProgressHUD.h"
#import "UYUHttpHandler.h"
#import "UYUUserInfo.h"
@interface UYUCreateViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *headTipLab;
@property (nonatomic, strong) UILabel *sexTitleLab;
@property (nonatomic, strong) UITextField *userNameTF;
@property (nonatomic, strong) UITextField *nickNameTF;
@property (nonatomic, strong) UITextField *mobileTF;
@property (nonatomic, strong) UITextField *birthDayTF;
@property (nonatomic, strong) UYUCheckBox *manButton;
@property (nonatomic, strong) UYUCheckBox *womanButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *dateToolBar;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) NSPredicate *userNamePredicate;

@end

@implementation UYUCreateViewController
- (NSPredicate *)userNamePredicate{
    if (_userNamePredicate == nil) {
        _userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Za-z0-9]{6,20}$"];
    }
    return _userNamePredicate;
}
- (UIButton *)createButton
{
    if (_createButton == nil) {
        _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createButton.backgroundColor = [UYUColor uyuGreenColor];
        _createButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _createButton.layer.cornerRadius = 3;
        _createButton.layer.masksToBounds = YES;
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_createButton setTitle:@"登 录" forState:UIControlStateNormal];
        
    }
    return _createButton;
}
- (UIToolbar *)dateToolBar
{

    if (_dateToolBar == nil) {
        _dateToolBar = [[ UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, AdaptWidth(30))];
        _dateToolBar.barStyle = UIBarStyleDefault;
        
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn buttonStyleUseForBarWithTarget:self Title:@"确定" buttonAction:@selector(datePickerDoneTouched:)];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn buttonStyleUseForBarWithTarget:self Title:@"取消" buttonAction:@selector(datePickerCancelTouched:)];
        
        UIBarButtonItem *doneButton   = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        
        UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        
        UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"选择生日"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:nil
                                                                       action:nil];
        titleButton.tintColor = [UIColor lightGrayColor];
        
        UIBarButtonItem *spaceButton1  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        UIBarButtonItem *spaceButton2  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        
        [_dateToolBar setItems:@[cancleButton, spaceButton1 ,titleButton, spaceButton2, doneButton]];
    }
    return _dateToolBar;
    

}

- (UIDatePicker *)datePicker{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_datePicker setDate:[NSDate date] animated:YES];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    return _datePicker;
}
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UILabel *)sexTitleLab
{
    if (_sexTitleLab == nil) {
        _sexTitleLab = [[UILabel alloc] init];
        _sexTitleLab.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _sexTitleLab.textColor = [UIColor lightGrayColor];
        _sexTitleLab.textAlignment = NSTextAlignmentLeft;
        _sexTitleLab.text = @"性别";
    }
    return _sexTitleLab;
}
- (UILabel *)headTipLab
{
    if (_headTipLab == nil) {
        _headTipLab = [[UILabel alloc] init];
        _headTipLab.font = [UIFont systemFontOfSize:AdaptWidth(13)];
        _headTipLab.textColor = [UYUColor uyuGreenColor];
        _headTipLab.textAlignment = NSTextAlignmentLeft;
        _headTipLab.numberOfLines = 0;
        _headTipLab.text = @"为客户注册优眼账户,用户名不能有特殊字符和中文，字母开头 6到16位 可以有下划线，默认密码为：111111";
    }
    return _headTipLab;
}

- (UITextField *)userNameTF
{
    if (_userNameTF == nil) {
        _userNameTF = [[UITextField alloc] init];
        _userNameTF.textAlignment = NSTextAlignmentLeft;
        _userNameTF.placeholder = @"用户名";
        _userNameTF.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _userNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _userNameTF.leftViewMode = UITextFieldViewModeAlways;
        _userNameTF.tag = 99;
        _userNameTF.delegate =self;
        
    }
    return _userNameTF;
}
- (UITextField *)nickNameTF
{
    if (_nickNameTF == nil) {
        _nickNameTF = [[UITextField alloc] init];
        _nickNameTF.textAlignment = NSTextAlignmentLeft;
        _nickNameTF.placeholder = @"昵称";
        _nickNameTF.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _nickNameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _nickNameTF.leftViewMode = UITextFieldViewModeAlways;
        _nickNameTF.tag = 100;
        _nickNameTF.delegate =self;
        
    }
    return _nickNameTF;
}
- (UITextField *)mobileTF
{
    if (_mobileTF == nil) {
        _mobileTF = [[UITextField alloc] init];
        _mobileTF.textAlignment = NSTextAlignmentLeft;
        _mobileTF.placeholder = @"手机号";
        _mobileTF.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _mobileTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _mobileTF.leftViewMode = UITextFieldViewModeAlways;
        _mobileTF.tag = 101;
        _mobileTF.delegate =self;
        _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _mobileTF;
}
- (UITextField *)birthDayTF
{
    if (_birthDayTF == nil) {
        _birthDayTF = [[UITextField alloc] init];
        _birthDayTF.textAlignment = NSTextAlignmentLeft;
        _birthDayTF.placeholder = @"生日";
        _birthDayTF.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _birthDayTF.inputView = self.datePicker;
        _birthDayTF.inputAccessoryView = self.dateToolBar;
        _birthDayTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _birthDayTF.leftViewMode = UITextFieldViewModeAlways;
        _birthDayTF.tag = 102;
        _birthDayTF.delegate =self;
    }
    return _birthDayTF;
}
- (UYUCheckBox *)manButton
{
    if (_manButton == nil) {
        _manButton = [UYUCheckBox buttonWithType:UIButtonTypeCustom];
        _manButton.selected = NO;
        [_manButton setImage:[UIImage imageNamed:@"ic_unselect"] forState:UIControlStateNormal];
        [_manButton setImage:[UIImage imageNamed:@"ic_select"] forState:UIControlStateSelected];
        [_manButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_manButton setTitle:@"男" forState:UIControlStateNormal];
    }
    return _manButton;
}

- (UYUCheckBox *)womanButton
{
    if (_womanButton == nil) {
        _womanButton = [UYUCheckBox buttonWithType:UIButtonTypeCustom];
        _womanButton.selected = YES;
        [_womanButton setImage:[UIImage imageNamed:@"ic_unselect"] forState:UIControlStateNormal];
        [_womanButton setImage:[UIImage imageNamed:@"ic_select"] forState:UIControlStateSelected];
        [_womanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_womanButton setTitle:@"女(默认)" forState:UIControlStateNormal];
    }
    return _womanButton;
}


- (void)addSubviews
{
    UIView *naviView = [self.view viewWithTag:kCustomeNaviViewTag];
    [self.view insertSubview:self.scrollView belowSubview:naviView];
    
    [self.scrollView addSubview:self.headTipLab];
    [self.scrollView addSubview:self.userNameTF];
    [self.scrollView addSubview:self.nickNameTF];
    [self.scrollView addSubview:self.mobileTF];
    [self.scrollView addSubview:self.birthDayTF];
    [self.scrollView addSubview:self.sexTitleLab];
    [self.scrollView addSubview:self.manButton];
    [self.scrollView addSubview:self.womanButton];
    [self.scrollView addSubview:self.createButton];
}

- (void)layoutSubviews{
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.headTipLab.frame = CGRectMake(15, 64, kScreenWidth - 15*2, AdaptWidth(60));
    self.userNameTF.frame = CGRectMake(15, _headTipLab.bottom+20, _headTipLab.width, 44);
    self.nickNameTF.frame = CGRectMake(15, _userNameTF.bottom+15, _headTipLab.width, 44);
    self.mobileTF.frame = CGRectMake(15, _nickNameTF.bottom+15, _headTipLab.width, 44);
    self.birthDayTF.frame = CGRectMake(15, _mobileTF.bottom+15, _headTipLab.width, 44);
    self.sexTitleLab.frame = CGRectMake(23, _birthDayTF.bottom+15, AdaptWidth(50), 44);
    self.manButton.frame = CGRectMake(_sexTitleLab.right + 10, _sexTitleLab.top, (_headTipLab.width - (_sexTitleLab.right + 20))/2.0 , 44);
    self.womanButton.frame = CGRectMake(_manButton.right, _manButton.top, _manButton.width, 44);
    self.createButton.frame = CGRectMake(15, _sexTitleLab.bottom+15, _headTipLab.width, 40);
}

- (void)configSubviews
{
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 1);
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, _userNameTF.height - 1, _userNameTF.width, 1)];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, _nickNameTF.height - 1, _nickNameTF.width, 1)];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, _mobileTF.height - 1, _mobileTF.width, 1)];
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, _birthDayTF.height - 1, _birthDayTF.width, 1)];
    line1.backgroundColor = [UYUColor uyuGreenColor];
    line2.backgroundColor = [UYUColor uyuGreenColor];
    line3.backgroundColor = [UYUColor uyuGreenColor];
    line4.backgroundColor = [UYUColor uyuGreenColor];
    [self.userNameTF addSubview:line1];
    [self.nickNameTF addSubview:line2];
    [self.mobileTF addSubview:line3];
    [self.birthDayTF addSubview:line4];
    
    [self.manButton addTarget:self action:@selector(selectManAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.womanButton addTarget:self action:@selector(selectWomanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.createButton addTarget:self action:@selector(createUserAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.userNameTF addTarget:self action:@selector(tfChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.nickNameTF addTarget:self action:@selector(tfChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.mobileTF addTarget:self action:@selector(tfChanged:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    [self layoutSubviews];
    [self configSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIButton Action
- (void)datePickerDoneTouched:(UIButton *)btn
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"]];
    NSDate *selectedDate = [self.datePicker date];
    NSString *selectedDateStr = [dateFormatter stringFromDate:selectedDate];
    self.birthDayTF.text = selectedDateStr;
    [self.view endEditing:YES];
}

- (void)datePickerCancelTouched:(UIButton *)btn
{
    [self.view endEditing:YES];
}

#pragma mark - 
#pragma UIButton action
- (void)selectManAction:(UIButton *)btn
{
    self.womanButton.selected = NO;
    self.manButton.selected = YES;
    [self.view endEditing:YES];
}

- (void)selectWomanAction:(UIButton *)btn{
    self.womanButton.selected = YES;
    self.manButton.selected = NO;
    [self.view endEditing:YES];
}

- (void)createUserAction:(UIButton *)btn{
    [self.view endEditing:YES];
    BOOL isMatch = [self.userNamePredicate evaluateWithObject:self.userNameTF.text];
    if (isMatch == NO) {
        [SVProgressHUD showErrorWithStatus:@"用户名不和法, 请重新输入"];
        return;
    }
    if ([self.mobileTF.text hasPrefix:@"1"] == NO) {
        [SVProgressHUD showErrorWithStatus:@"手机号不合法, 请重新输入"];
        return;
    }
    NSString *account = self.userNameTF.text;
    NSString *nickName = self.nickNameTF.text;
    NSString *mobile = self.mobileTF.text;
    NSString *birthday = self.birthDayTF.text;
    NSString *sex = @"1";
    if (self.manButton.selected == NO) {
        sex = @"1";
    }else{
        sex = @"0";
    }
    [[UYUHttpHandler shareInstance] createUserWithAccount:account
                                                 nickName:nickName
                                                   mobile:mobile
                                                 birthday:birthday
                                                      sex:sex
                                                    token:[UYUUserInfo shared].sessionId
                                             createUserId:[UYUUserInfo shared].uyuOldUserId
                                                  success:^(NSDictionary *responseDictionary) {
                                                      NSString *code = [responseDictionary[@"code"] description];
                                                      if ([code isEqualToString:@"0"]) {
                                                          [SVProgressHUD showSuccessWithStatus:@"创建用户成功"];
                                                      }else{
                                                          [SVProgressHUD showErrorWithStatus:responseDictionary[@"message"]];

                                                      }
    } failure:^(NSDictionary *errorDictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];
        });
    }];
}

- (void)tfChanged:(UITextField *)tf
{
    switch (tf.tag) {
        case 99:
        {
            NSString *userName = tf.text;
            if (userName.length > 20) {
                self.userNameTF.text = [userName substringWithRange:NSMakeRange(0, 20)];
            }
        }
            break;
        case 100:
        {
            NSString *nickName = tf.text;
            if (nickName.length > 8) {
                self.nickNameTF.text = [nickName substringWithRange:NSMakeRange(0, 8)];
            }
        }
            break;
        case 101:
        {
            NSString *mobile = tf.text;
            if (mobile.length > 11) {
                self.mobileTF.text = [mobile substringWithRange:NSMakeRange(0, 11)];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        switch (textField.tag) {
            case 99:
                
                break;
            case 100:
                [self.scrollView setContentOffset:CGPointMake(0, self.userNameTF.top - 44)];
                break;
            case 101:
                [self.scrollView setContentOffset:CGPointMake(0, self.nickNameTF.top - 44)];
                break;
            case 102:
                [self.scrollView setContentOffset:CGPointMake(0, self.mobileTF.top - 44)];

                break;
            default:
                break;
        }
    }];
    return YES;
}

- (void)keyboardDidHidden:(NSNotification *)noti
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}
- (void)cancelKeyboard
{
    [self.view endEditing:YES];
}
@end
