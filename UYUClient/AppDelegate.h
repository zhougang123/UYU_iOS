//
//  AppDelegate.h
//  UYUClient
//
//  Created by mac on 17/3/11.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userid;

- (void)showTabbarViewController;
- (void)showLoginViewController;

@end
extern AppDelegate *shareAppDelegate;
