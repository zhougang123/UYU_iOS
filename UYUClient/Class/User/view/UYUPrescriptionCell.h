//
//  UYUPrescriptionCell.h
//  UYUClient
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#define kPrescriptionCellHeight AdaptWidth(136)

@protocol PrescriptionCellDelegate <NSObject>

- (void)prescriptionDeleteWithIndexPath:(UITableViewCell *)cell;

@end



@interface UYUPrescriptionCell : UITableViewCell

@property (nonatomic, weak) id<PrescriptionCellDelegate> delegate;

- (void)handlePrescriptionWithName:(NSString *)name
                         serialNum:(NSString *)serialNum
                         trainTime:(NSString *)times
                           headImg:(UIImage *)icon;
@end
