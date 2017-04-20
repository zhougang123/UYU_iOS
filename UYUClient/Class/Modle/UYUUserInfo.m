//
//  UYUUserInfo.m
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUUserInfo.h"

@implementation UYUUserInfo

+ (instancetype)shared
{
    static UYUUserInfo *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (void)clearUserInfo
{
    [UYUUserInfo shared].storeId = nil;
    [UYUUserInfo shared].cdNewUserId = nil;
    [UYUUserInfo shared].uyuOldUserId = nil;
    [UYUUserInfo shared].isPrepayment = nil;
    [UYUUserInfo shared].sessionId = nil;
    [UYUUserInfo shared].cookie = nil;
    [UYUUserInfo shared].cookieDict = nil;
    [UYUUserInfo shared].mobile = nil;
    [UYUUserInfo shared].password = nil;
}
@end
