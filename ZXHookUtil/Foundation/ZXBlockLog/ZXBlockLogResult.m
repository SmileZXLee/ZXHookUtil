//
//  ZXBlockLogResult.m
//  ZXBlockLogDemo
//
//  Created by 李兆祥 on 2019/5/20.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXBlockLogResult.h"
#import "ZXBlockLogTool.h"
@implementation ZXBlockLogResult
- (instancetype)initWithMethodSignature:(NSMethodSignature *)methodSignature{
    if(self = [super init]){
        _returnDecription = [ZXBlockLogTool getDecWithType:methodSignature.methodReturnType];
        NSUInteger argIndex = 0;
        NSMutableArray *argDecsArr = [NSMutableArray array];
        while (argIndex < methodSignature.numberOfArguments){
            if(argIndex){
                const char *argType = [methodSignature getArgumentTypeAtIndex:argIndex];
                NSString *argDec = [ZXBlockLogTool getDecWithType:argType];
                [argDecsArr addObject:argDec];
            }
            argIndex ++;
        }
        _argDecriptions = [argDecsArr mutableCopy];
    }
    return self;
}
- (NSString *)description{
    NSString *declareArgs = @"";
    NSString *impleArgs = @"";
    NSUInteger argIndex = 0;
    for (NSString *argDec in self.argDecriptions) {
        argIndex ++;
        declareArgs = [declareArgs stringByAppendingString:[NSString stringWithFormat:@"%@,",argDec]];
        impleArgs = [impleArgs stringByAppendingString:[NSString stringWithFormat:@"%@arg%lu,",[argDec hasSuffix:@"*"] ? argDec : [argDec stringByAppendingString:@" "],argIndex]];
    }
    declareArgs = declareArgs.length ? [declareArgs substringToIndex:declareArgs.length - 1] : declareArgs;
    impleArgs = impleArgs.length ? [impleArgs substringToIndex:impleArgs.length - 1] : impleArgs;
    NSString *declareDescription = [NSString stringWithFormat:@"%@(^)(%@)",self.returnDecription,declareArgs];
    NSString *impleDescription = [NSString stringWithFormat:@"^%@(%@)",self.returnDecription,impleArgs];
    return [NSString stringWithFormat:@"\n[Declare]%@\n[Imple]%@",declareDescription,impleDescription];
}
@end
