//
//  UYUPresModel.h
//  UYUClient
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UYUPresModel : NSObject

+ (NSDictionary *)stereoscopeWithId:(NSString *)presId
                              times:(NSString *)time
                          trainType:(NSString *)type;

+ (NSDictionary *)fracturedRulerWithId:(NSString *)presId
                                 times:(NSString *)time
                             trainType:(NSString *)type;

+ (NSDictionary *)reversalWithId:(NSString *)presId
                           times:(NSString *)time
                         eyeType:(NSString *)type
                    leftEyeGrade:(NSString *)l_grade
                   rightEyeGrade:(NSString *)r_grade;

+ (NSDictionary *)redGreenRedWithId:(NSString *)presId
                              times:(NSString *)time
                           fontSize:(NSString *)fontSize;

+ (NSDictionary *)approachWithId:(NSString *)presId
                           times:(NSString *)time;

+ (NSDictionary *)rgVariableWithId:(NSString *)presId
                             times:(NSString *)time
                         trainType:(NSString *)type;

+ (NSDictionary *)rgFixedWithId:(NSString *)presId
                          times:(NSString *)time
                      trainType:(NSString *)type;

+ (NSDictionary *)glanceWithId:(NSString *)presId
                         times:(NSString *)time
                      fontSize:(NSString *)fontSize;

+ (NSDictionary *)followWithId:(NSString *)presId
                         times:(NSString *)time
                      lineType:(NSString *)lineType
                     lineCount:(NSString *)lineCount
                      imgCount:(NSString *)imgCount;
@end
