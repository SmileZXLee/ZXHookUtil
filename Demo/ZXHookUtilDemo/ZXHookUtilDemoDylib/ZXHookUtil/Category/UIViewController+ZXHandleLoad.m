//
//  UIViewController+ZXHandleLoad.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "UIViewController+ZXHandleLoad.h"
#import <objc/runtime.h>
#import "ZXMethodLog.h"
typedef void (* _VIMP)(id, SEL, ...);

@implementation UIViewController (ZXHandleLoad)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        _VIMP viewDidLoad_VIMP = (_VIMP)method_getImplementation(viewDidLoad);
        
        method_setImplementation(viewDidLoad, imp_implementationWithBlock(^ (id target , SEL action){
            
            // the system viewDidLoad method
            viewDidLoad_VIMP(target , @selector(viewDidLoad));
            
            // the new add NSLog method
            //NSLog(@"自定义log :%@ did load",target);
            //[ZXMethodLog addClassTrace:NSStringFromClass(self)];
            
        }));
        
        
    });
}
@end
