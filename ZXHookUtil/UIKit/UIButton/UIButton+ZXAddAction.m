//
//  UIButton+ZXAddAction.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "UIButton+ZXAddAction.h"
#import <objc/runtime.h>
static char overViewKey;
@implementation UIButton (ZXAddAction)
-(void)addClickAction:(ZXActionBlock)callBack{
     objc_setAssociatedObject(self, &overViewKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonClick{
    ZXActionBlock actionBlock = objc_getAssociatedObject(self, &overViewKey);
    if(actionBlock){
        actionBlock(self);
    }
}
@end
