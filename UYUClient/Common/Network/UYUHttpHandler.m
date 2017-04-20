//
//  UYUHttpHandler.m
//  UYUClient
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUHttpHandler.h"
#import "AppConfig.h"
#import "NSString+Tools.h"
#import "CYTools.h"
#import "UYUUserInfo.h"


//uyu老系统登录的三个接口
#define kUYUExistPhone @"/verify/existsPhone"

#define kUYUOptometrist @"/optometrist"

#define kUYUGetAccessToken @"/getAccessToken"
//我们登录接口
#define kCDLogin @"/store/v1/api/login"
//获取说有客户接口
#define kUYUNearAll @"/receptions/near_all"
//创建消费者接口
#define kUYUCreateUser @"/uyuuser"
//获取处方接口
#define kUYUGetPrescritions @"/getUserTrainPresScheme"

#define kUYUCreatePresScheme @"/uyuuser/createTrainPresScheme"

#define kCDStoreConsumerList @"/store/v1/api/store_consumer_list"

typedef void (^ReqSuccessCB)(NSURLSessionDataTask *task, id responseObject);

typedef void (^ReqFailureCB)(NSURLSessionDataTask *task, NSError *error);



@interface UYUHttpHandler ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *sessionJsonManager;
@property (nonatomic, strong) NSString *uyuCookie;

@end

@implementation UYUHttpHandler

+(instancetype)shareInstance
{
    static UYUHttpHandler *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
        _instance.sessionManager = [AFHTTPSessionManager manager];
        _instance.sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _instance.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _instance.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _instance.sessionJsonManager = [AFHTTPSessionManager manager];
        _instance.sessionJsonManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _instance.sessionJsonManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _instance.sessionJsonManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    });
    return _instance;
}

- (void)httpGETWithUrl:(NSString *)url
            parameters:(NSDictionary *)params
               success:(ReqSuccessCB) success
               failure:(ReqFailureCB) failure
{
    [[UYUHttpHandler shareInstance].sessionManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(task, responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(task, error);
        });
    }];
    
}

- (void)httpPOSTWithUrl:(NSString *)url
             parameters:(NSDictionary *)params
                success:(ReqSuccessCB) success
                failure:(ReqFailureCB) failure
{
    [[UYUHttpHandler shareInstance].sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(task, responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(task, error);
        });
    }];
}

- (NSString *)addSoltWithPwd:(NSString *)pwd
{
    return [NSString stringWithFormat:@"360%@Huyan", pwd];
}
- (void)cdLoginWithPhone:(NSString *)phone
                password:(NSString *)pwd
                 success:(SuccessCB)successCB
                 failure:(FailureCB) failureCB
{
    NSString *urlStr = [kCDBaseUrl stringByAppendingString:kCDLogin];
    [UYUUserInfo shared].mobile = phone;
    [UYUUserInfo shared].password = pwd;
    
    NSString *encPwd = [[self addSoltWithPwd:pwd] encPassword];
    NSDictionary *param = @{
                            @"mobile":phone,
                            @"new_password":[pwd handleWithMD5].lowercaseString,
                            @"old_password":encPwd
                            };
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance] httpPOSTWithUrl:urlStr parameters:kkParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];

            
            if ([praseDict valueForKey:@"handle_error_msg"]) {
                failureCB(praseDict);
            }else{
                
                NSMutableDictionary *respDict = [NSMutableDictionary dictionaryWithDictionary:praseDict];
                //获取cookie中sessionid
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                
                NSDictionary *responseFields = [httpResponse allHeaderFields];
                
                NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:responseFields forURL:httpResponse.URL];
                if ([cookies count]) {
                    NSHTTPCookie *httpCookie = (NSHTTPCookie *)cookies[0];
                    [UYUUserInfo shared].cookie = httpCookie;
                    if ([httpCookie.name isEqualToString:@"sessionid"]) {
                        respDict[@"sessionid"] = httpCookie.value;
                    }
                    NSDictionary *cookieDict = httpCookie.properties;
                    [UYUUserInfo shared].cookieDict = cookieDict;
                }
                if ([respDict[@"respcd"] isEqualToString:@"0000"]) {
                    [self handleWithUserInfo:respDict];
                    [self saveInUserDefatltWithDict:respDict];
                }
                successCB(respDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"验证手机号返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];
}


- (void)handleWithUserInfo:(NSDictionary *)responseDictionary;
{
    [UYUUserInfo shared].storeId = [responseDictionary[@"data"][@"userid"] description];
    [UYUUserInfo shared].cdNewUserId = [responseDictionary[@"data"][@"login_id"] description];
    [UYUUserInfo shared].uyuOldUserId = [responseDictionary[@"data"][@"login_old_id"] description];
    [UYUUserInfo shared].isPrepayment = [responseDictionary[@"data"][@"is_prepayment"] description];
    [UYUUserInfo shared].sessionId = [responseDictionary[@"sessionid"] description];
}

- (void)saveInUserDefatltWithDict:(NSDictionary *)responseDictionary
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setValue:[responseDictionary[@"data"][@"userid"] description] forKey:@"userid"];
    [userInfo setValue:[responseDictionary[@"data"][@"login_id"] description] forKey:@"login_id"];
    [userInfo setValue:[responseDictionary[@"data"][@"login_old_id"] description] forKey:@"login_old_id"];
    [userInfo setValue:[responseDictionary[@"data"][@"is_prepayment"] description] forKey:@"is_prepayment"];
    [userInfo setValue:[responseDictionary[@"sessionid"] description] forKey:@"sessionid"];
    [userInfo setValue:[UYUUserInfo shared].cookieDict forKey:@"cookieDict"];
    [userdefault setValue:userInfo forKey:@"currentUserInfo"];
    
    
    [userdefault synchronize];
    
    
}


- (NSDictionary *)praseWithResponseData:(NSData *)data{
    NSError *praseError = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments  error:&praseError];
    if (praseError) {
        jsonDict = @{kHttpErrorMsg:@"验证手机号出错"};
    }
    return jsonDict;
}


- (void)existWithPhone:(NSString *)phone
               success:(SuccessCB)successCB
               failure:(FailureCB) failureCB
{
    NSString *urlStr = [kUYUBaseUrl stringByAppendingString:kUYUExistPhone];
    NSDictionary *param = @{
        @"phone_num":phone
    };
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance] httpGETWithUrl:urlStr parameters:kkParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
            if ([praseDict valueForKey:@"handle_error_msg"]  || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                //获取cookie中sessionid
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

                NSDictionary *responseFields = [httpResponse allHeaderFields];
                
                NSString *cookieStr = responseFields[@"Set-Cookie"];
                
                [UYUHttpHandler shareInstance].uyuCookie = cookieStr;
                
                NSMutableDictionary *respDict = [NSMutableDictionary dictionaryWithDictionary:praseDict];
                
                [respDict setValue:cookieStr forKey:@"Set-Cookie"];
                
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"验证手机号返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];
}

- (void)optometristWithPhone:(NSString *)phone
                    password:(NSString *)pwd
                     success:(SuccessCB)successCB
                     failure:(FailureCB) failureCB
{
    
    NSString *urlStr = [kUYUBaseUrl stringByAppendingString:kUYUOptometrist];
    NSString *encPwd = [[self addSoltWithPwd:pwd] encPassword];
     [self clearLocalCache];
    NSDictionary *param = @{
                            @"UserName":phone,
                            @"Password":encPwd
                            };
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance] httpGETWithUrl:urlStr parameters:kkParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
            if ([praseDict valueForKey:@"handle_error_msg"] || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"验证手机号返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];
}

- (void)getAccessToken:(NSString *)userid
            deviceType:(NSString *)devType
                  code:(NSString *)code
               success:(SuccessCB)successCB
               failure:(FailureCB) failureCB
{
    NSString *urlStr = [kUYUBaseUrl stringByAppendingString:kUYUGetAccessToken];
     [self clearLocalCache];
    NSDictionary *param = @{
                            @"uid":userid,
                            @"dm":devType,
                            @"code":code
                            };
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance] httpGETWithUrl:urlStr parameters:kkParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
        
            if ([praseDict valueForKey:@"handle_error_msg"] || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"验证手机号返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];
}

- (void)nearAllConsumer:(NSString *)token
                 userId:(NSString *)userid
                success:(SuccessCB)successCB
                failure:(FailureCB) failureCB
{
    NSString *urlStr = [kUYUBaseUrl stringByAppendingString:kUYUNearAll];
     [self clearLocalCache];
    NSDictionary *param = @{
                            @"tk":token,
                            @"uid":userid
                            };
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance] httpGETWithUrl:urlStr parameters:kkParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
            
            if ([praseDict valueForKey:@"handle_error_msg"] || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"验证手机号返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];
}

- (void)cdAllConsumerStoreUserId:(NSString *)storeUserId
                        seUserId:(NSString *)seUserId
                         success:(SuccessCB)successCB
                         failure:(FailureCB)failureCB
{
    NSString *urlStr = [kCDBaseUrl stringByAppendingString:kCDStoreConsumerList];
    [self clearLocalCache];
    NSDictionary *param = @{
                            @"store_userid":storeUserId,
                            @"se_userid":seUserId
                            };
    
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance] httpGETWithUrl:urlStr parameters:kkParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
            
            if ([praseDict valueForKey:@"handle_error_msg"] || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"验证手机号返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];
}





- (void)clearCookie
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *obj in cookieArray) {
        [cookieJar deleteCookie:obj];
    }
}

- (void)createUserWithAccount:(NSString *)account
                     nickName:(NSString *)nickName
                       mobile:(NSString *)mobile
                     birthday:(NSString *)birthday
                          sex:(NSString *)sex
                        token:(NSString *)token
                 createUserId:(NSString *)cUserId
                      success:(SuccessCB)successCB
                      failure:(FailureCB) failureCB
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?tk=%@", kUYUBaseUrl, kUYUCreateUser, token];
     [self clearLocalCache];
    NSString*pwd = [[self addSoltWithPwd:@"111111"] encPassword];;
    NSDictionary *user_extra_infos = @{@"temp_phone_num":mobile, @"temp_email":@""};
    NSDictionary *param = @{
                            @"nick_name":nickName,
                            @"birth_day":birthday,
                            @"phone_num":mobile,
                            @"login_name":account,
                            @"sex":sex,
                            @"email":@"",
                            @"user_extra_infos":user_extra_infos,
                            @"portrait_type":@"null",
                            @"portrait_data":@"",
                            @"occupation":@"",
                            @"password":pwd,
                            @"id":@"null",
                            @"uid":cUserId
                            };
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance].sessionJsonManager POST:urlStr parameters:kkParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
            if ([praseDict valueForKey:@"handle_error_msg"] || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"获取处方返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];
}


- (void)getPrescriptionsWithUserId:(NSString *)userId
                        needCreate:(NSString *)needCreate
                             token:(NSString *)token
                           success:(SuccessCB)successCB
                           failure:(FailureCB) failureCB
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/uyuuser/%@%@", kUYUBaseUrl, userId, kUYUGetPrescritions];
     [self clearLocalCache];
    NSDictionary *param = @{
                            @"tk":token,
                            @"need_create":needCreate
                            };
    
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance] httpGETWithUrl:urlStr parameters:kkParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
            if ([praseDict valueForKey:@"handle_error_msg"] || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"获取处方返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];

}


- (void)createTrainPresSchemeWithToken:(NSString *)token
                             presParam:(NSDictionary *)param
                               success:(SuccessCB)successCB
                               failure:(FailureCB) failureCB
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?tk=%@", kUYUBaseUrl, kUYUCreatePresScheme, token];
    
    [self clearLocalCache];
    
    NSMutableDictionary *kkParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [kkParam addEntriesFromDictionary:[CYTools deviceInfo]];
    
    [[UYUHttpHandler shareInstance].sessionJsonManager POST:urlStr parameters:kkParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *praseDict = [self praseWithResponseData:(NSData *)responseObject];
            if ([praseDict valueForKey:@"handle_error_msg"] || [praseDict count] == 0) {
                failureCB(praseDict);
            }else{
                successCB(praseDict);
            }
        }else{
            failureCB(@{kHttpErrorMsg:@"获取处方返回的数据异常"});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureCB(@{kHttpErrorMsg:@"网络错误, 请稍后重试"});
    }];

}

- (void)clearLocalCache
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *obj in cookieArray) {
        [cookieJar deleteCookie:obj];
    }
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[UYUUserInfo shared].cookie];
    
}
@end
