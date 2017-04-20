//
//  UYUHttpHandler.h
//  UYUClient
//
//  Created by mac on 17/4/8.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessCB)(NSDictionary *responseDictionary);

typedef void(^FailureCB)(NSDictionary *errorDictionary);

#define kHttpErrorMsg @"handle_error_msg"

@interface UYUHttpHandler : NSObject

+(instancetype)shareInstance;

- (void)clearCookie;

- (void)cdLoginWithPhone:(NSString *)phone
                password:(NSString *)pwd
                 success:(SuccessCB)successCB
                 failure:(FailureCB) failureCB;

- (void)existWithPhone:(NSString *)phone
               success:(SuccessCB)successCB
               failure:(FailureCB) failureCB;

- (void)optometristWithPhone:(NSString *)phone
                    password:(NSString *)pwd
                     success:(SuccessCB)successCB
                     failure:(FailureCB) failureCB;

- (void)getAccessToken:(NSString *)userid
            deviceType:(NSString *)devType
                  code:(NSString *)code
               success:(SuccessCB)successCB
               failure:(FailureCB) failureCB;

- (void)nearAllConsumer:(NSString *)token
                 userId:(NSString *)userid
                success:(SuccessCB)successCB
                failure:(FailureCB) failureCB;

- (void)cdAllConsumerStoreUserId:(NSString *)storeUserId
                        seUserId:(NSString *)seUserId
                         success:(SuccessCB)successCB
                         failure:(FailureCB) failureCB;

- (void)createUserWithAccount:(NSString *)account
                     nickName:(NSString *)nickName
                       mobile:(NSString *)mobile
                     birthday:(NSString *)birthday
                          sex:(NSString *)sex
                        token:(NSString *)token
                 createUserId:(NSString *)cUserId
                      success:(SuccessCB)successCB
                      failure:(FailureCB) failureCB;

- (void)getPrescriptionsWithUserId:(NSString *)userId
                        needCreate:(NSString *)needCreade
                             token:(NSString *)token
                           success:(SuccessCB)successCB
                           failure:(FailureCB) failureCB;

- (void)createTrainPresSchemeWithToken:(NSString *)token
                             presParam:(NSDictionary *)param
                               success:(SuccessCB)successCB
                               failure:(FailureCB) failureCB;

@end
