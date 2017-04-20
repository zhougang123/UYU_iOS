//
//  UIButton+ButtonStyle.h
//  Finance
//
//  Created by mac on 15/6/26.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ButtonStyle)

/***
 ***红色BG，白色title的button
 ***/
- (void)buttonStyleRedBG_WhiteTitleWithTarget:(id)target Title:(NSString *)title buttonAction:(SEL)action;

/***
 ***用于UIToolBar
 ***/
- (void)buttonStyleUseForBarWithTarget:(id)target Title:(NSString *)title buttonAction:(SEL)action;

@end
