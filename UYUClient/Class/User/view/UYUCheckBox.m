//
//  UYUCheckBox.m
//  UYUClient
//
//  Created by mac on 17/4/11.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUCheckBox.h"
#import "UIView+YSKit.h"
@implementation UYUCheckBox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(26, 0, self.width - 26, self.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, (self.height-22)/2.0, 22, 22);
}
@end
