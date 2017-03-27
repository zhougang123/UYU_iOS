//
//  UYUWebViewController.m
//  UYUClient
//
//  Created by mac on 17/3/14.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUWebViewController.h"
#import "Macro.h"
#import "WebViewJavascriptBridge.h"
#import "Macro.h"
#import "UIView+YSKit.h"
#import "UYUColor.h"
#import "MJRefresh.h"


@interface UYUWebViewController ()<UIGestureRecognizerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIView *customNavigationView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIWebView *h5WebView;
@property (nonatomic, strong) WebViewJavascriptBridge* jsBridge;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) BOOL hiddenRightBtn;
@property (nonatomic, strong) NSArray *idleImages;
@property (nonatomic, strong) NSArray *refreshingImages;

@end

@implementation UYUWebViewController

- (instancetype)initWithUrlString:(NSString *)url rightHidden:(BOOL)hidden
{
    self = [super init];
    if (self) {
        self.urlString = url;
        self.hiddenRightBtn = hidden;
        self.canPullDownRefresh = NO;
        self.canPullUpRefresh = NO;
        
    }
    return self;
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
#pragma mark - getter and setter
- (UIWebView *)h5WebView
{
    if (_h5WebView == nil) {
        _h5WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 52)];
    }
    return _h5WebView;
}

- (WebViewJavascriptBridge *)jsBridge
{
    if (_jsBridge == nil) {
        _jsBridge = [WebViewJavascriptBridge bridgeForWebView:self.h5WebView];
        [_jsBridge setWebViewDelegate:self];
        
    }
    return _jsBridge;
}

- (UIView *)customNavigationView
{
    if (_customNavigationView == nil) {
        _customNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 64)];
        _customNavigationView.backgroundColor = [UYUColor uyuGreenColor];
    }
    return _customNavigationView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - AdaptWidth(120))/2.0, 20, AdaptWidth(120), 44)];
        _titleLabel.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(kScreenWidth - AdaptWidth(80) - 15, 20, AdaptWidth(80), 44);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        [_rightBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightBtn;
}

- (UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(5, 20, AdaptWidth(50), 44);
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        [_leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftBtn;
}
- (void)logout:(UIButton *)btn
{
    [shareAppDelegate showLoginViewController];
}
- (void)popViewController:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -life circle
- (void)addCustomNavigationSubviews
{
    [self.view addSubview:self.customNavigationView];
    
    [self.customNavigationView addSubview:self.titleLabel];
    if ([self.navigationController.viewControllers count] > 1) {
        [self.customNavigationView addSubview:self.leftBtn];
    }
    if (self.hiddenRightBtn == NO) {
        [self.customNavigationView addSubview:self.rightBtn];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [WebViewJavascriptBridge enableLogging];
    
    [self setupNavigationController];
    
    [self addCustomNavigationSubviews];
    
    [self addSubviews];
    
    [self registJSCallHander];
    
    if (self.canPullUpRefresh == YES) {
        [self addWebViewPullUpRefresh];
    }
    if (self.canPullDownRefresh == YES) {
        [self addWebViewPullDownRefresh];
    }
    [self loadRequestUrl];
    
    if ([self.navigationController.viewControllers count] > 1) {
        self.h5WebView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    }
    
}

#pragma mark -load Web view
- (void)loadRequestUrl
{
    NSURL *url = [[NSURL alloc] initWithString:self.urlString];
    [self.h5WebView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

- (void)loadLocal
{
    NSString *htmlPath = [kLocalWebBaseUrl stringByAppendingPathComponent:@"index.html"];
    
    NSError *error = nil;
    
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        [self.h5WebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:htmlPath]];
    }else{
        NSLog(@"web页面转换为html string 出错 %@", [error localizedDescription]);
    }
}

- (void)registJSCallHander{
    __weak typeof(self) weakSelf = self;
    [self.jsBridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        if (responseCallback) {
            // 反馈给JS
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSString *userid = [NSString stringWithFormat:@"%@", [userdefault valueForKey:@"userid"]];
            responseCallback(@{@"userid": userid});
        }
    }];
    
    [self.jsBridge registerHandler:@"openUrl" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        //开新页面
        [weakSelf jsCallOBJCOpenUrl:data];
        if (responseCallback) {
            // 反馈给JS
            responseCallback(@{@"cb": @"OK"});
        }
    }];
    
    [self.jsBridge registerHandler:@"alert" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        //开新页面
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:data[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        if (responseCallback) {
            // 反馈给JS
            responseCallback(@{@"cb": @"OK"});
        }
    }];
    
    [self.jsBridge registerHandler:@"popToRoot" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        //开新页面
        if (responseCallback) {
            // 反馈给JS
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            responseCallback(@{@"cb": @"OK"});
        }
    }];
}

- (void)addSubviews
{
    [self.view addSubview:self.h5WebView];
}

- (void)jsCallOBJCOpenUrl:(NSDictionary *)data
{
    UYUWebViewController *newVC = [[UYUWebViewController alloc] initWithUrlString:data[@"url"] rightHidden:YES];
    if ([data[@"pullDown"] isEqualToString:@"1"]) {
        newVC.canPullDownRefresh = YES;
    }
    if ([data[@"pullUp"] isEqualToString:@"1"]) {
        newVC.canPullUpRefresh = YES;
    }
    newVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newVC animated:YES];
}
#pragma mark - NavigationController

- (void)setupNavigationController {
    self.navigationController.navigationBarHidden = YES;
    
    if (self.navigationController.viewControllers.count == 1) {
        [self navigationCanDragBack:YES];
    }
}

#pragma mark -- Pop Gesture

- (void)navigationCanDragBack:(BOOL)bCanDragBack {
    self.navigationController.interactivePopGestureRecognizer.enabled = bCanDragBack;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    else{
        return YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleLabel.text = [self.h5WebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


#pragma mark - MJRefresh
- (void)addWebViewPullDownRefresh
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
    [header setImages:self.idleImages forState:MJRefreshStateIdle];
    [header setImages:self.refreshingImages forState:MJRefreshStatePulling];
    [header setImages:self.refreshingImages forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.h5WebView.scrollView.mj_header = header;
    
}

- (void)addWebViewPullUpRefresh{
    __weak typeof(self) weakSelf = self;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf.h5WebView.scrollView.mj_footer endRefreshing];
        [weakSelf.jsBridge callHandler:@"pullUpRefresh" data:@{@"kkkkk":@"ddddd"} responseCallback:^(id responseData) {
            NSLog(@"回调成功");
        }];
    }];
    self.h5WebView.scrollView.mj_footer = footer;

}
- (void)pullDown{
    [self.h5WebView.scrollView.mj_header endRefreshing];
    [self.jsBridge callHandler:@"updateCurrentView" data:@{@"page":@"1"} responseCallback:^(id responseData) {
        NSLog(@"回调成功");
    }];
}
@end
