//
//  AppDelegate.m
//  UYUClient
//
//  Created by mac on 17/3/11.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "AppDelegate.h"
#import "UYUTrainViewController.h"
#import "UYUUserInfo.h"
#import "UYUHttpHandler.h"
#import "SVProgressHUD.h"
#import "Macro.h"
AppDelegate *shareAppDelegate;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    shareAppDelegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self showLoginViewController];
    
     [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogin) name:kAutoLoginNotification object:nil];
    return YES;
}

- (void)showLoginViewController;
{
    UYULoginViewController *loginVC = [[UYULoginViewController alloc] init];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = naviVC;
}
- (void)showTabbarViewController
{
    UYUTabBarController *tab = [[UYUTabBarController alloc] init];
    self.window.rootViewController = tab;
}

- (void)autoLogin
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
        NSString *mobile = [UYUUserInfo shared].mobile;
        NSString *password = [UYUUserInfo shared].password;
        if (mobile.length == 0 || password.length == 0) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            mobile = [userDefault objectForKey:@"mobile"];
            password = [userDefault objectForKey:@"password"];
        }
        
        if (mobile.length == 0 || password.length == 0){
            [self showLoginViewController];
        }else{
            [[UYUHttpHandler shareInstance] cdLoginWithPhone:mobile
                                                    password:password
                                                     success:^(NSDictionary *responseDictionary) {
                                                         if ([responseDictionary[@"respcd"] isEqualToString:@"0000"]) {
                                                             
                                                             //缓存返回的数据
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [SVProgressHUD dismiss];
                                                             });
                                                         }else{
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [self showLoginViewController];
                                                             });
                                                         }

            } failure:^(NSDictionary *errorDictionary) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:errorDictionary[kHttpErrorMsg]];
                    [self showLoginViewController];
                });
            }];
        }
    });
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
