//
//  ZXBlockLog.m
//  ZXBlockLogDemo
//
//  Created by 李兆祥 on 2019/5/20.
//  Copyright © 2019 李兆祥. All rights reserved.
//  基于CTBlockDescription

#import "ZXBlockLog.h"
#import "CTBlockDescription.h"

@implementation ZXBlockLog
+ (ZXBlockLogResult *)logWithBlock:(id)block{
    if(!block){
       NSAssert(NO, @"参数block为空");
    }
    NSString *blockClassName = NSStringFromClass([block class]);
    if(!([blockClassName isEqualToString:@"__NSGlobalBlock__"] || [blockClassName isEqualToString:@"__NSStackBlock__"] || [blockClassName isEqualToString:@"__NSMallocBlock__"])){
        NSAssert(NO, @"参数block不是block对象");
    }
    CTBlockDescription *blockDec = [[CTBlockDescription alloc]initWithBlock:block];
    ZXBlockLogResult *logResult = [[ZXBlockLogResult alloc]initWithMethodSignature:blockDec.blockSignature];
    return logResult;
}

@end
