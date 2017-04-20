//
//  CYTools.m
//  UYUClient
//
//  Created by mac on 17/4/17.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "CYTools.h"
#import "UIDevice+Tools.h"
#import "Macro.h"

@implementation CYTools
+ (NSDictionary *)deviceInfo
{
    NSString *deviceType = [[UIDevice currentDevice] iphoneType];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *appVersion = AppVersionShort;
    return @{@"os":deviceType, @"sys_version":sysVersion, @"app_version":appVersion};
}
@end
