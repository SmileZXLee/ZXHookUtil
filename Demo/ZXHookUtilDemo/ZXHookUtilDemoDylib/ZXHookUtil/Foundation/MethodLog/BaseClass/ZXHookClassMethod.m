//
//  ZXHoolClassMethod.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXHookClassMethod.h"
#import "ZXMethodLog.h"
@interface ZXHookClassMethod()
@property(nonatomic, assign)Method method;
@end
@implementation ZXHookClassMethod
-(instancetype)initWithMethod:(Method)method{
    if(self = [super init]){
        self.method = method;
        [self setValue:[self getMethodName] forKey:@"methodName"];
        [self setValue:[self getMethodReturnType] forKey:@"methodReturnType"];
    }
    return self;
}
-(void)setMethodType:(ZXMethodType)methodType{
    _methodType = methodType;
    [self setValue:[self getMethodDescription] forKey:@"methodDescription"];
}
-(NSString *)getMethodName{
    SEL selector = method_getName(self.method);
    return NSStringFromSelector(selector);
}
-(NSString *)getMethodReturnType{
    const char *returnTypeChar = method_copyReturnType(self.method);
    NSString *returnType = [NSString stringWithUTF8String: returnTypeChar];
    return [ZXMethodLog getTypeWithOrgType:returnType];
}
-(NSString *)getMethodDescription{
    NSArray *arsgArr = [self getMethodArgTypes];
    NSString *prefix = self.methodType == ZXMethodTypeInstance ? @"-" : @"+";
    NSString *methonDescription = [NSString stringWithFormat:@"%@%@",prefix,self.methodReturnType];
    NSArray *sepArr = [self.methodName componentsSeparatedByString:@":"];
    NSString *argsStr = @"";
    for (int i = 0; i < arsgArr.count; i++) {
        NSString *arg = [NSString stringWithFormat:@"%@ arg%i ",arsgArr[i],i + 1];
        NSString *argPrefix = i <sepArr.count ? sepArr[i] : @"";
        argsStr = [argsStr stringByAppendingString:[NSString stringWithFormat:@"%@ %@",argPrefix,arg]];
    }
    
    if(arsgArr.count){
        argsStr = [argsStr substringToIndex:argsStr.length - 1];
    }else{
        argsStr = self.methodName;
    }
    methonDescription =  [methonDescription stringByAppendingString:argsStr];
    return methonDescription;
}


-(NSMutableArray *)getMethodArgTypes{
    long argCount = method_getNumberOfArguments(self.method);
    NSMutableArray *argTypesArr = [NSMutableArray array];
    for(int i = 0;i < argCount;i++){
        if(i <= 1)continue;
        const char * argTypeChar = method_copyArgumentType(self.method,i);
        NSString *argType = [NSString stringWithUTF8String: argTypeChar];
        if([[ZXMethodLog getTypeMapperDic].allKeys containsObject:argType]){
            [argTypesArr addObject:[ZXMethodLog getValueFromDicWithArrType:[ZXMethodLog getTypeMapperDic] key:argType]];
        }
    }
    return argTypesArr;
}
@end
