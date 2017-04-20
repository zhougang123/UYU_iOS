//
//  UYUPresNameMenu.h
//  UYUClient
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UYUPresNameMenuDelegate <NSObject>

- (void)selectPrescritionType:(NSString *)type;

@end


@interface UYUPresNameMenu : UIView

@property (nonatomic, weak) id<UYUPresNameMenuDelegate> delegate;
@property (nonatomic, copy) NSString *selectType;
+ (instancetype)shared;

- (void)showPrescriptionWithCurrentPresType:(NSString *)type;

- (void)hiddenPrescriPtion;

@end
