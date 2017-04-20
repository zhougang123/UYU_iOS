//
//  UYUUserInfo.h
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UYUUserInfo : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *cdNewUserId;
@property (nonatomic, copy) NSString *uyuOldUserId;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *isPrepayment;
@property (nonatomic, strong) NSHTTPCookie *cookie;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSDictionary *cookieDict;
+ (instancetype)shared;
- (void)clearUserInfo;
@end
