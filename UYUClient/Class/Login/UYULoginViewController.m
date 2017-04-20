//
//  UYULoginViewController.m
//  UYUClient
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYULoginViewController.h"

#import "UYUWebViewController.h"

#import "Macro.h"

#import "UYUColor.h"

#import "UIView+YSKit.h"

#import "SVProgressHUD.h"

#import "AFNetworking.h"

#import "AppConfig.h"

#import "NSString+Tools.h"

#import "UYUHttpHandler.h"

#import "UIDevice+Tools.h"

#import "UYUUserInfo.h"

@interface UYULoginViewController ()
@property (nonatomic, strong) UIImageView *uyuImageView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton    *loginBtn;
@property (nonatomic, assign) BOOL        keyboardIsHidden;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) UILabel *versionLab;
@property (nonatomic, strong) UIButton    *forgetPwdBtn;
@property (nonatomic, strong) UIButton    *registeBtn;
@end

@implementation UYULoginViewController

- (UILabel *)versionLab{
    if (_versionLab == nil) {
        _versionLab = [[UILabel alloc] init];
        _versionLab.font = [UIFont systemFontOfSize:13];
        _versionLab.textColor = [UIColor lightGrayColor];
        _versionLab.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLab;
}
-(UITextField *)phoneTF
{
    if (_phoneTF == nil) {
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
        _phoneTF.placeholder = @"请输入您的手机号";
        _phoneTF.layer.cornerRadius = 3;
        _phoneTF.layer.borderColor = [UYUColor uyuGreenColor].CGColor;
        _phoneTF.layer.borderWidth = 0.5;
        _phoneTF.layer.masksToBounds = YES;
        _phoneTF.font = [UIFont systemFontOfSize:15];
        _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneTF.tag = 1000;
//        _phoneTF.text = @"19212341000";
        _phoneTF.text = @"13475481254";
    }
    return _phoneTF;
}

-(UITextField *)passwordTF
{
    if (_passwordTF == nil) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.keyboardType = UIKeyboardTypePhonePad;
        _passwordTF.placeholder = @"请输入密码";
        _passwordTF.layer.cornerRadius = 3;
        _passwordTF.layer.borderColor = [UYUColor uyuGreenColor].CGColor;
        _passwordTF.layer.borderWidth = 0.5;
        _passwordTF.layer.masksToBounds = YES;
        _passwordTF.font = [UIFont systemFontOfSize:15];
        _passwordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
        _passwordTF.tag = 1001;
        _passwordTF.secureTextEntry = YES;
//        _passwordTF.text = @"341000";
//        _passwordTF.text = @"123456";
    }
    return _passwordTF;
}

- (UIImageView *)uyuImageView
{
    if (_uyuImageView == nil) {
        _uyuImageView = [[UIImageView alloc] init];
        [_uyuImageView setImage:[UIImage imageNamed:@"login_icon"]];
    }
    return _uyuImageView;
}

- (UIButton *)loginBtn
{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UYUColor uyuGreenColor];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _loginBtn.layer.cornerRadius = 3;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        
    }
    return _loginBtn;
}

- (UIButton *)forgetPwdBtn
{
    if (_forgetPwdBtn == nil) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPwdBtn.backgroundColor = [UIColor whiteColor];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _forgetPwdBtn.layer.cornerRadius = 3;
        _forgetPwdBtn.layer.masksToBounds = YES;
        [_forgetPwdBtn setTitleColor:[UYUColor uyuGreenColor] forState:UIControlStateNormal];
        [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        
    }
    return _forgetPwdBtn;
}

- (UIButton *)registeBtn
{
    if (_registeBtn == nil) {
        _registeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registeBtn.backgroundColor = [UYUColor uyuGreenColor];
        _registeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _registeBtn.layer.cornerRadius = 3;
        _registeBtn.layer.masksToBounds = YES;
        [_registeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registeBtn setTitle:@"注 册" forState:UIControlStateNormal];
        
    }
    return _registeBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    [self layoutSubviews];
    [self addActions];
    [self setupNotifications];
    self.keyboardIsHidden = YES;
    
    
    self.versionLab.text = [NSString stringWithFormat:@"v %@", AppVersionShort];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UYUUserInfo shared] clearUserInfo];
    [self clearLocalCache];
}
- (void)addSubviews{
    [self.view addSubview:self.uyuImageView];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registeBtn];
    [self.view addSubview:self.forgetPwdBtn];
    [self.view addSubview:self.versionLab];
}
- (void)layoutSubviews{
    self.uyuImageView.frame = CGRectMake((kScreenWidth - AdaptWidth(100))/2.0, AdaptWidth(88), AdaptWidth(100), AdaptWidth(100));
    self.phoneTF.frame = CGRectMake(AdaptWidth(30), kScreenHeight/2.0-AdaptWidth(40), kScreenWidth - AdaptWidth(30)*2, AdaptWidth(40));
    self.passwordTF.frame = CGRectMake(_phoneTF.left, _phoneTF.bottom+12, _phoneTF.width, _phoneTF.height);
    self.loginBtn.frame = CGRectMake(_phoneTF.left, _passwordTF.bottom+12, _phoneTF.width, _phoneTF.height);
    self.registeBtn.frame = CGRectMake(_phoneTF.left, _loginBtn.bottom+12, _phoneTF.width, _phoneTF.height);
    self.forgetPwdBtn.frame = CGRectMake(_phoneTF.left, _registeBtn.bottom+10, _phoneTF.width, _phoneTF.height);
    self.versionLab.frame = CGRectMake(0, kScreenHeight - AdaptWidth(40), kScreenWidth, AdaptWidth(40));
    
}

- (void)addActions
{
    [self.phoneTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetPwdBtn addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.registeBtn addTarget:self action:@selector(registeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedView:)]];
}
- (void)textFieldChanged:(UITextField *)tf
{
    if (tf.tag == 1000) {
        NSString *phone = self.phoneTF.text;
        if (phone.length > 11) {
            self.phoneTF.text = [phone substringWithRange:NSMakeRange(0, 11)];
        }
    }else if(tf.tag == 1001){
        NSString *password = self.passwordTF.text;
        if (password.length > 18) {
            self.passwordTF.text = [password substringWithRange:NSMakeRange(0, 18)];
        }
    }
}
- (void)registeAction:(UIButton *)btn
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kCDBaseUrl, registerUrl];
    UYUWebViewController *newVC = [[UYUWebViewController alloc] initWithUrlString:urlStr];
    [self.navigationController pushViewController:newVC animated:YES];
}
- (void)forgetPwdAction:(UIButton *)btn
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kCDBaseUrl, forgetPwdUrl];
    UYUWebViewController *newVC = [[UYUWebViewController alloc] initWithUrlString:urlStr];
    [self.navigationController pushViewController:newVC animated:YES];
}
- (void)login:(UIButton *)btn
{
    NSString *phone = self.phoneTF.text;
    NSString *password = self.passwordTF.text;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.6]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    if (phone.length < 11 || ![phone hasPrefix:@"1"]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if (password.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位以上的密码"];
        return;
    }

    
    [[UYUHttpHandler shareInstance] clearCookie];
    
    [SVProgressHUD show];
    
    [self cdLoginPhone:phone password:password];
}

- (void)cdLoginPhone:(NSString *)phone password:(NSString *)pwd
{
    [[UYUHttpHandler shareInstance] cdLoginWithPhone:phone password:pwd success:^(NSDictionary *responseDictionary) {
        if ([responseDictionary[@"respcd"] isEqualToString:@"0000"]) {

            //缓存返回的数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [shareAppDelegate showTabbarViewController];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:responseDictionary[@"resperr"]];
            });
        }
        
    } failure:^(NSDictionary *errorDictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];
        });
    }];
}

#pragma mark -
#pragma mark 测试
- (void)existWithPhone:(NSString *)phone password:(NSString *)pwd
{
    [[UYUHttpHandler shareInstance] existWithPhone:phone success:^(NSDictionary *responseDictionary) {
        NSString *respCode = [responseDictionary[@"code"] description];
        if ([respCode isEqualToString:@"0"]) {
            //手机号存在，下一步登录
//            [self optometristPhone:phone password:pwd];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:responseDictionary[@"message"]];
            });
        }
    } failure:^(NSDictionary *errorDictionary) {
        
    }];
}


- (void)optometristPhone:(NSString *)phone password:(NSString *)pwd
{
    [[UYUHttpHandler shareInstance] optometristWithPhone:phone password:pwd success:^(NSDictionary *responseDictionary) {
        [self getAccessTokenWithUserid:responseDictionary[@"id"] code:responseDictionary[@"code"]];
    } failure:^(NSDictionary *errorDictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];
        });
    }];
}

- (void)getAccessTokenWithUserid:(NSString *)userid code:(NSString *)code{
    
    NSString *phoneType = [[UIDevice currentDevice] iphoneType];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
//    NSString *phone = self.phoneTF.text;
//    NSString *password = self.passwordTF.text;
    [[UYUHttpHandler shareInstance] getAccessToken:userid
                                        deviceType:[phoneType stringByAppendingString:sysVersion]
                                              code:code
                                           success:^(NSDictionary *responseDictionary) {
                                               
                                               
                                    
//                                               [self cdLoginPhone:phone password:password];
    } failure:^(NSDictionary *errorDictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];
        });
    }];
}

- (void)tapedView:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark - Private Method

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.keyboardIsHidden == YES) {
        self.keyboardIsHidden = NO;
        NSDictionary *userInfo = [notification userInfo];
        NSValue *value = [userInfo objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey];
        CGFloat keyboardHeight = value.CGRectValue.size.height;
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:[duration floatValue] animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
            self.uyuImageView.top = self.uyuImageView.top - keyboardHeight;
            self.phoneTF.top = self.phoneTF.top - keyboardHeight;
            self.passwordTF.top = self.passwordTF.top - keyboardHeight;
            self.loginBtn.top = self.loginBtn.top - keyboardHeight;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    if (self.keyboardIsHidden == NO) {
        self.keyboardIsHidden = YES;
        NSDictionary *userInfo = [notification userInfo];
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:[duration floatValue] animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
            [self layoutSubviews];
            [self.view layoutIfNeeded];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 清空cache
- (void)clearLocalCache
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *obj in cookieArray) {
        [cookieJar deleteCookie:obj];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end
