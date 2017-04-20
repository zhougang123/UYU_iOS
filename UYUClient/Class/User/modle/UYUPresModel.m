//
//  UYUPresModel.m
//  UYUClient
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUPresModel.h"

@implementation UYUPresModel

+ (NSDictionary *)stereoscopeWithId:(NSString *)presId
                              times:(NSString *)time
                          trainType:(NSString *)type{
    NSDictionary *stereoscopeDict = @{
                                      @"id":presId,
                                      @"training_type":type,
                                      @"repeat_training_times":time,
                                      @"dwell_time":@"10",
                                      @"scheme_process_num":@"0",
                                      @"screen_location":@"200.00",
                                      @"start_difficulty":@"1",
                                      @"train_item_type":@"stereoscope"
                
    };
    return stereoscopeDict;
}

+ (NSDictionary *)fracturedRulerWithId:(NSString *)presId
                                 times:(NSString *)time
                             trainType:(NSString *)type{
    NSDictionary *frDict = @{
                             @"id":presId,
                             @"training_type":type,
                             @"repeat_training_times":time,
                             @"baffle_location":@"260.00",
                             @"dwell_time":@"5",
                             @"scheme_process_num":@"1",
                             @"start_difficulty":@"1",
                             @"train_item_type":@"fractured_ruler",
                             };
    return frDict;
}

+ (NSDictionary *)reversalWithId:(NSString *)presId
                           times:(NSString *)time
                         eyeType:(NSString *)type
                    leftEyeGrade:(NSString *)l_grade
                   rightEyeGrade:(NSString *)r_grade
{
    NSDictionary *reversalDict = @{
                                   @"id":presId,
                                   @"eye_type":type,
                                   @"repeat_training_times":time,
                                   @"l_negative_degree_level":l_grade,
                                   @"l_positive_degree_level":l_grade,
                                   @"r_negative_degree_level":r_grade,
                                   @"r_positive_degree_level":r_grade,
                                   @"loop_negative_num":@"1",
                                   @"loop_negative_num_right":@"0",
                                   @"loop_positive_num":@"1",
                                   @"loop_positive_num_right":@"0",
                                   @"loop_unit_type":@"0",
                                   @"negative_letter_size":@"6",
                                   @"negative_letter_size_right":@"6",
                                   @"positive_letter_size":@"6",
                                   @"positive_letter_size_right":@"6",
                                   @"scheme_process_num":@"2",
                                   @"train_item_type":@"reversal",
                                   @"training_content_article_id":@"0",
                                   @"training_content_category_id":@"0",
                                   @"training_content_loop_mode":@"0",
                                   @"training_content_type":@"1",
                                   @"training_duration":@"300",
                                   };
    return reversalDict;
}

+ (NSDictionary *)redGreenRedWithId:(NSString *)presId
                              times:(NSString *)time
                           fontSize:(NSString *)fontSize
{
    NSDictionary *rgDict = @{
                             @"id":presId,
                             @"repeat_training_times":time,
                             @"letter_size":fontSize,
                             @"letter_count":@"100",
                             @"scheme_process_num":@"3",
                             @"train_item_type":@"red_green_read",
                             @"training_content_article_id":@"0",
                             @"training_content_type":@"1"
                             };
    return rgDict;
}

+ (NSDictionary *)approachWithId:(NSString *)presId
                           times:(NSString *)time

{
    NSDictionary *apDict = @{
                             @"id":presId,
                             @"repeat_training_times":time,
                             @"created_at":@"2017-04-14 19:59:07",
                             @"dwell_time":@"10",
                             @"scheme_process_num":@"4",
                             @"train_item_type":@"approach",
                             };
    return apDict;
}

+ (NSDictionary *)rgVariableWithId:(NSString *)presId
                             times:(NSString *)time
                         trainType:(NSString *)type
{
    NSDictionary *rgVariable = @{
                                 @"id":presId,
                                 @"training_type":type,
                                 @"repeat_training_times":time,
                                 @"scheme_process_num":@"5",
                                 @"train_item_type":@"r_g_variable_vector",
                                 };
    return rgVariable;
}

+ (NSDictionary *)rgFixedWithId:(NSString *)presId
                          times:(NSString *)time
                      trainType:(NSString *)type{
    NSDictionary *rgFixed = @{
                              @"id":presId,
                              @"training_type":type,
                              @"repeat_training_times":time,
                              @"dwell_time":@"10",
                              @"scheme_process_num":@"6",
                              @"start_difficulty":@"1",
                              @"train_item_type":@"r_g_fixed_vector"
                              };
    return rgFixed;
}

+ (NSDictionary *)glanceWithId:(NSString *)presId
                         times:(NSString *)time
                      fontSize:(NSString *)fontSize
{
    NSDictionary *glanceDict = @{
                                 @"id":presId,
                                 @"repeat_training_times":time,
                                 @"letter_size":fontSize,
                                 @"letter_count":@"1",
                                 @"scheme_process_num":@"7",
                                 @"train_item_type":@"glance",
                                 @"training_content_article_id":@"0",
                                 @"training_content_type":@"1"
                                 };
    return glanceDict;
}
+ (NSDictionary *)followWithId:(NSString *)presId
                         times:(NSString *)time
                      lineType:(NSString *)lineType
                     lineCount:(NSString *)lineCount
                      imgCount:(NSString *)imgCount{
    NSDictionary *followDict = @{
                                 @"id":presId,
                                 @"repeat_training_times":time,
                                 @"line_count":lineCount,
                                 @"line_type":lineType,
                                 @"pic_count":imgCount,
                                 @"scheme_process_num":@"8",
                                 @"train_item_type":@"follow",
                                 };
    return followDict;
}
@end
