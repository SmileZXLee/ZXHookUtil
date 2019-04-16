//
//  NSObject+ZXHandleLoad.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "NSObject+ZXHandleLoad.h"
#import "NSObject+ZXHookClassUtil.h"
#import "ZXMethodLog.h"
typedef void (* _VIMP)(id, SEL, ...);

@implementation NSObject (ZXHandleLoad)

+ (void)load{
    NSLog(@"loadClass[%@]",self);
}
@end
