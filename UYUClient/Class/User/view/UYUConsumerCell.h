//
//  UYUConsumerCell.h
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kConsumerCellHeight 60
@interface UYUConsumerCell : UITableViewCell


- (void)handleCellWithName:(NSString *)nickName
                createDate:(NSString *)time
                      type:(NSString *)type
                headeImage:(UIImage *)icon;

@end
