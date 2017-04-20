//
//  UIButton+Block.h
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickActionBlock) (UIButton *obj);

@interface UIButton (Block)

- (void)addBlock:(ClickActionBlock)clickBlock forEvent:(UIControlEvents)event;
@end
