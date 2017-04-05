//
//  UYULoginViewController.m
//  UYUClient
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYULoginViewController.h"

#import "Macro.h"

#import "UYUColor.h"

#import "UIView+YSKit.h"

#import "SVProgressHUD.h"

#import "AFNetworking.h"

#import "AppConfig.h"

#import "NSString+Tools.h"

@interface UYULoginViewController ()
@property (nonatomic, strong) UIImageView *uyuImageView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton    *loginBtn;
@property (nonatomic, assign) BOOL        keyboardIsHidden;

@end

@implementation UYULoginViewController
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
        _phoneTF.text = @"13893541383";
        
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
        _passwordTF.text = @"541383";
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    [self layoutSubviews];
    [self addActions];
    [self setupNotifications];
    self.keyboardIsHidden = YES;
    
}

- (void)addSubviews{
    [self.view addSubview:self.uyuImageView];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.loginBtn];
}
- (void)layoutSubviews{
    self.uyuImageView.frame = CGRectMake((kScreenWidth - AdaptWidth(100))/2.0, AdaptWidth(88), AdaptWidth(100), AdaptWidth(100));
    self.phoneTF.frame = CGRectMake(AdaptWidth(30), kScreenHeight/2.0, kScreenWidth - AdaptWidth(30)*2, AdaptWidth(40));
    self.passwordTF.frame = CGRectMake(AdaptWidth(30), CGRectGetMaxY(_phoneTF.frame)+15, kScreenWidth - AdaptWidth(30)*2, AdaptWidth(40));
    self.loginBtn.frame = CGRectMake(AdaptWidth(30), CGRectGetMaxY(_passwordTF.frame)+15, kScreenWidth - AdaptWidth(30)*2, AdaptWidth(40));
}

- (void)addActions
{
    [self.phoneTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
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
   

    [self clearLocalCache];
    
    AFHTTPSessionManager *httpManage = [AFHTTPSessionManager manager];
    httpManage.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    httpManage.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManage.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = @{@"mobile": phone, @"password": [password handleWithMD5].lowercaseString};
    
    NSString *urlString = [baseUrl stringByAppendingString:@"/store/v1/api/login"];
    
    [httpManage POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
        
        NSDictionary *responeHeaderDict = respone.allHeaderFields;
        
        NSString *cookie = responeHeaderDict[@"Set-Cookie"];
        
        NSLog(@"cookie %@", cookie);
        
        NSError *praseError = nil;
        NSData *jsonData = (NSData *)responseObject;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments  error:&praseError];
        if ([jsonDict[@"respcd"] isEqualToString:@"0000"]) {
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:[jsonDict[@"data"][@"userid"] description] forKey:@"userid"];
            [userInfo setValue:[jsonDict[@"data"][@"is_prepayment"] description] forKey:@"is_prepayment"];
            [userdefault setValue:userInfo forKey:@"currentUserInfo"];
            [userdefault synchronize];
            [shareAppDelegate showTabbarViewController];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:jsonDict[@"resperr"]];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败, 请稍后重试"];
        NSLog(@"失败 %@", error);
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
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
@end
