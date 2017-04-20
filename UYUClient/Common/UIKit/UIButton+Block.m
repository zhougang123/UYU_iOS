//
//  UIButton+Block.m
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

static id key;

- (void)addBlock:(ClickActionBlock)clickBlock forEvent:(UIControlEvents)event{
    
    objc_setAssociatedObject (self , &key , clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC );
    
    [ self addTarget:self action:@selector (goAction:) forControlEvents:event];
    
    
}

- (void)goAction:(UIButton *)sender{
    ClickActionBlock block = (ClickActionBlock)objc_getAssociatedObject (self , &key );
    
    if (block) {
        block(sender);
    }
}



@end
