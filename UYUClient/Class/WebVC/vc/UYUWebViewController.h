//
//  UYUWebViewController.h
//  UYUClient
//
//  Created by mac on 17/3/14.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//
#import <UIKit/UIKit.h>

#define kLocalWebBaseUrl [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Web/html"]

@interface UYUWebViewController : UIViewController
@property (nonatomic, assign) BOOL canPullDownRefresh;
@property (nonatomic, assign) BOOL canPullUpRefresh;

- (instancetype)initWithUrlString:(NSString *)url;

@end
