//
//  ZXBlockLogTool.m
//  ZXBlockLogDemo
//
//  Created by 李兆祥 on 2019/5/20.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXBlockLogTool.h"
#import <UIKit/UIKit.h>
@implementation ZXBlockLogTool
+ (NSString *)getDecWithType:(const char *)type{
    NSDictionary *typeMapperDic = [self getTypeMapperDic];
    NSString *typeStr = [NSString stringWithUTF8String:type];
    
    if([typeMapperDic.allKeys containsObject:typeStr]){
        return typeMapperDic[typeStr];
    }
    NSRange typeRange = [typeStr rangeOfString:@"\".*?\"" options:NSRegularExpressionSearch];
    if(typeRange.location == NSNotFound){
        if([typeStr hasPrefix:@"T@"]){
            return @"id";
        }else{
            return [NSString stringWithFormat:@"[变量类型识别失败，原类型为]%@",typeStr];
        }
        
    }
    NSString *resTypeStr = [typeStr substringWithRange:typeRange];
    resTypeStr = [[resTypeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""]stringByAppendingString:@" *"];
    return resTypeStr ;
}

+ (NSDictionary *)getTypeMapperDic{
    static NSDictionary *typeMapperDic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeMapperDic = @{[NSString stringWithUTF8String:@encode(char)] : @"char",
                          [NSString stringWithUTF8String:@encode(int)] : @"int",
                          [NSString stringWithUTF8String:@encode(short)] : @"short",
                          [NSString stringWithUTF8String:@encode(long)] : @"long",
                          [NSString stringWithUTF8String:@encode(long long)] : @"long long",
                          [NSString stringWithUTF8String:@encode(unsigned char)] : @"unsigned char",
                          [NSString stringWithUTF8String:@encode(unsigned int)] : @"unsigned int",
                          [NSString stringWithUTF8String:@encode(unsigned short)] : @"unsigned short",
                          [NSString stringWithUTF8String:@encode(unsigned long)] : @"unsigned long",
                          [NSString stringWithUTF8String:@encode(unsigned long long)] : @"unsigned long long",
                          [NSString stringWithUTF8String:@encode(float)] : @"float",
                          [NSString stringWithUTF8String:@encode(double)] : @"double",
                          [NSString stringWithUTF8String:@encode(BOOL)] : @"BOOL",
                          [NSString stringWithUTF8String:@encode(void)] : @"void",
                          [NSString stringWithUTF8String:@encode(char *)] : @"char *",
                          [NSString stringWithUTF8String:@encode(id)] : @"id",
                          [NSString stringWithUTF8String:@encode(Class)] : @"Class",
                          [NSString stringWithUTF8String:@encode(SEL)] : @"SEL",
                          [NSString stringWithUTF8String:@encode(CGRect)] : @"CGRect",
                          [NSString stringWithUTF8String:@encode(CGPoint)] : @"CGPoint",
                          [NSString stringWithUTF8String:@encode(CGSize)] : @"CGSize",
                          [NSString stringWithUTF8String:@encode(CGVector)] : @"CGVector",
                          [NSString stringWithUTF8String:@encode(CGAffineTransform)] : @"CGAffineTransform",
                          [NSString stringWithUTF8String:@encode(UIOffset)] : @"UIOffset",
                          [NSString stringWithUTF8String:@encode(UIEdgeInsets)] : @"UIEdgeInsets",
                          @"@?":@"block"
                          };
    });
    return typeMapperDic;
}
@end
