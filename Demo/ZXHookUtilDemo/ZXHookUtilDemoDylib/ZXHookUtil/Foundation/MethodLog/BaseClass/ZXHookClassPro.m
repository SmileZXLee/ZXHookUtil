//
//  ZXHoolClassPro.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXHookClassPro.h"
#import "NSString+ZXHookRegular.h"
@implementation ZXHookClassPro
-(void)setProType:(NSString *)proType{
    _proTypeOrg = proType;
    NSString *resProType = [proType containsString:@"@"] ? [proType matchStrWithPre:@"T@" sub:@","] : [proType matchStrWithPre:@"T" sub:@","];
    NSDictionary *proTypeMapper = [self getProTypeMapper];
    if([proTypeMapper.allKeys containsObject:resProType]){
        resProType = [proTypeMapper valueForKey:resProType];
    }else{
        resProType = [resProType removeAllElements:@[@"@\"",@"\""]];
    }
    _proType = resProType;
}

-(NSDictionary *)getProTypeMapper{
    return
  @{@"i":@"int",@"s":@"short",@"f":@"float",@"d":@"double",@"l":@"long",@"q":@"longlong",@"c":@"char",@"b":@"Bool",@"^{objc_ivar=}":@"Ivar",@"^{objc_method=}":@"Method",@"@?":@"Block",@"#":@"Class",@":":@"SEL",@"@":@"id"};
}
@end
