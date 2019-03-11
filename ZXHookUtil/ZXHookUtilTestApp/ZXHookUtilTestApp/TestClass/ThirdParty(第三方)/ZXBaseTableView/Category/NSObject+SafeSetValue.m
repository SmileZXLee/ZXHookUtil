//
//  NSObject+SafeSetValue.m
//  ZXBaseTableView
//
//  Created by 李兆祥 on 2018/8/20.
//  Copyright © 2018年 李兆祥. All rights reserved.
//  Github地址：https://github.com/SmileZXLee/ZXBaseTableView

#import "NSObject+SafeSetValue.h"
#import "ZXBaseGlobalData.h"
#import <objc/runtime.h>
@implementation NSObject (SafeSetValue)
-(NSMutableArray *)getPropertyNames{
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class],&count);
    for(NSUInteger i = 0;i < count;i++){
        const char *propertyNameChar = property_getName(properties[i]);
        NSString *propertyNameStr = [NSString stringWithUTF8String: propertyNameChar];
        [propertyNamesArr addObject:propertyNameStr];
        
    }
    return propertyNamesArr;
}
-(NSMutableArray *)getAllPropertyNames{
    NSString *className = NSStringFromClass([self class]);
    if([[ZXBaseGlobalData shareInstance].allProNameList.allKeys containsObject:className]){
        return [[ZXBaseGlobalData shareInstance].allProNameList valueForKey:className];
    }
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    propertyNamesArr = [self getPropertyNames];
    if([self isSysClass])return propertyNamesArr;
    Class class = self.superclass;
    while (true) {
        if(![class isSysClass]){
            NSMutableArray *superclassproArr = [class getPropertyNames];
            for (NSString *superclassproStr in superclassproArr) {
                [propertyNamesArr addObject:superclassproStr];
            }
            
        }else{
            break;
        }
        NSObject *obj = [class new];
        class = obj.superclass;
    }
    [[ZXBaseGlobalData shareInstance].allProNameList setValue:propertyNamesArr forKey:className];
    return propertyNamesArr;
}
-(NSMutableArray *)getAllValues{
    NSMutableArray *valuesArr = [NSMutableArray array];
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class],&count);
    for(NSUInteger i = 0;i < count;i++){
        const char *propertyNameChar = property_getName(properties[i]);
        NSString *propertyNameStr = [NSString stringWithUTF8String: propertyNameChar];
        id obj = [self valueForKeyPath:propertyNameStr];
        if(obj){
            [valuesArr addObject:obj];
        }else{
            [valuesArr addObject:@""];
        }
        
    }
    return valuesArr;
}
-(void)safeSetValue:(id)value forKey:(NSString *)key{
    if([[self getPropertyNames] containsObject:key]){
        [self setValue:value forKey:key];
    }
}
-(void)safeSetValue:(id)value forKeyPath:(NSString *)key{
    if([[self getAllPropertyNames] containsObject:key]){
        [self setValue:value forKeyPath:key];
    }
}
-(instancetype)safeValueForKey:(NSString *)key{
    if([[self getPropertyNames] containsObject:key]){
        return [self valueForKey:key];
    }else{
        return @"";
    }
}
-(instancetype)safeValueForKeyPath:(NSString *)key{
    if([[self getAllPropertyNames] containsObject:key]){
        return [self valueForKeyPath:key];
    }else{
        return @"";
    }
}
-(BOOL)superclassIsSysClass{
    return !([NSBundle bundleForClass:self.superclass] == [NSBundle mainBundle]);
}
-(BOOL)isSysClass{
    return !([NSBundle bundleForClass:[self class]] == [NSBundle mainBundle]);
}
@end
