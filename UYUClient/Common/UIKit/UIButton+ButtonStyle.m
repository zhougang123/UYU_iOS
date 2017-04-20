//
//  UIButton+ButtonStyle.m
//  Finance
//
//  Created by mac on 15/6/26.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UIButton+ButtonStyle.h"
#import "Macro.h"

@implementation UIButton (ButtonStyle)

- (void)buttonStyleRedBG_WhiteTitleWithTarget:(id)target Title:(NSString *)title buttonAction:(SEL)action
{
    if (!title && !action) {
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2.0;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonStyleUseForBarWithTarget:(id)target Title:(NSString *)title buttonAction:(SEL)action
{
    if (!title && !action) {
        return;
    }
    self.frame = CGRectMake(0, 0, 44, 30);
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:AdaptWidth(14)]];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}



@end
