//
//  NSObject+ZXHookClassUtil.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "NSObject+ZXHookClassUtil.h"
#import "NSString+ZXHookRegular.h"
#import <objc/runtime.h>
#import "ZXHookUtil.h"
#import "ZXMethodLog.h"
#import "ZXDataHandle.h"
#define ClassName NSStringFromClass([self class])
static NSMutableDictionary *classContentRecursiveDic;
static NSMutableDictionary *classContentSubDic;
static NSMutableDictionary *classContentSubDic2;
static NSString *lastBelong;
@implementation NSObject (ZXHookClassUtil)
+(NSMutableArray *)getPropertyNames{
    if([[ZXHookUtil sharedInstance].proNameList.allKeys containsObject:ClassName]){
        return [[ZXHookUtil sharedInstance].allProNameList valueForKey:ClassName];
    }
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class],&count);
    if(!properties)return nil;
    Method *methods  = class_copyMethodList([self class],&count);
    for(NSUInteger i = 0;i < count;i++){
        const char *propertyNameChar = property_getName(properties[i]);
        NSString *propertyNameStr = [NSString stringWithUTF8String: propertyNameChar];
        
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *methodName = NSStringFromSelector(selector);
        [propertyNamesArr addObject:propertyNameStr];
    }
    free(properties);
    [[ZXHookUtil sharedInstance].proNameList setValue:propertyNamesArr forKey:ClassName];
    return propertyNamesArr;
}
+(ZXHookClass *)getClassContent{
    if([[ZXHookUtil sharedInstance].proNameList.allKeys containsObject:ClassName]){
        return [[ZXHookUtil sharedInstance].allProNameList valueForKey:ClassName];
    }
    ZXHookClass *hookClass = [[ZXHookClass alloc]init];
    NSMutableArray *proNamesArr = [NSMutableArray array];
    u_int proCount;
    u_int methodCount;
    objc_property_t *properties  = class_copyPropertyList([self class],&proCount);
    Method *instanceMethods  = class_copyMethodList([self class],&methodCount);
    if(!properties || !instanceMethods)return nil;
    for(NSUInteger i = 0;i < proCount;i++){
        ZXHookClassPro *hookClassPro = [[ZXHookClassPro alloc]init];
        objc_property_t pro = properties[i];
        const char *propertyNameChar = property_getName(pro);
        NSString *propertyName = [NSString stringWithUTF8String: propertyNameChar];
        const char *propertyTypeChar = property_getAttributes(properties[i]);
        NSString *propertyType = [NSString stringWithUTF8String: propertyTypeChar];
        hookClassPro.pro = pro;
        hookClassPro.proName = propertyName;
        hookClassPro.proType = propertyType;
        [hookClass.classProsArr addObject:hookClassPro];
        [proNamesArr addObject:propertyName];
        [proNamesArr addObject:[NSString stringWithFormat:@"set%@:",[propertyName upperFirstCharacter]]];
    }
    for(NSUInteger i = 0;i < methodCount;i++){
        
        Method method = instanceMethods[i];
        ZXHookClassMethod *hookClassMethod = [[ZXHookClassMethod alloc]initWithMethod:method];
        hookClassMethod.methodType = ZXMethodTypeInstance;
        if(![proNamesArr containsObject:hookClassMethod.methodName] && ![[ZXMethodLog getBlackList]containsObject:hookClassMethod.methodName]){
            if(![hookClassMethod.methodName hasPrefix:@"qhd_"]){
                [hookClass.classMethodsArr addObject:hookClassMethod];
            }
        }
    }
    methodCount = 0;
    const char *clsName = class_getName(self);
    Class metaClass = objc_getMetaClass(clsName);
    Method *staticMethodList = class_copyMethodList(metaClass, &methodCount);
    for (int i = 0; i < methodCount ; i ++) {
        Method method = staticMethodList[i];
        ZXHookClassMethod *hookClassMethod = [[ZXHookClassMethod alloc]initWithMethod:method];
        hookClassMethod.methodType = ZXMethodTypeStatic;
        if(![[ZXMethodLog getBlackList]containsObject:hookClassMethod.methodName]){
            [hookClass.classMethodsArr addObject:hookClassMethod];
        }
    }
    free(properties);
    free(instanceMethods);
    free(staticMethodList);
    [[ZXHookUtil sharedInstance].proNameList setValue:hookClass forKey:ClassName];
    return hookClass;
}
//+(void)getClassContentRecursive:(Class)cls{
//    ZXHookClass *hookClass = [cls getClassContent];
//    for (ZXHoolClassPro *classPro in hookClass.classProsArr) {
//        Class subCls = NSClassFromString(classPro.proType);
//        if(subCls){
//            if(![self isFoundationClass:subCls]){
//                [self getClassContentRecursive:subCls];
//            }
//        }
//    }
//}
+(void)getClassContentRecursive:(Class)cls belongs:(NSString *)belongs{
    if([self isFoundationClass:cls]){
        //NSLog(@"cls--%@",cls);
        return;
    }
    ZXHookClass *hookClass = [cls getClassContent];
    if(belongs.length){
        if([classContentSubDic.allKeys containsObject:belongs]){
            id subObj = [classContentSubDic valueForKey:belongs];
            NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
            [subDic setValue:hookClass forKey:NSStringFromClass(cls)];
            [subDic setValue:[subObj zx_toDic] forKey:@"ZXClassContent"];
            [classContentSubDic setValue:[subObj zx_toDic] forKey:belongs];
            //[classContentSubDic2 setValue:subDic forKey:belongs];
            if(lastBelong){
                
                
                [self setDicRecursive:classContentRecursiveDic value:classContentSubDic forKey:lastBelong];
                //[classContentRecursiveDic setValue:classContentSubDic forKey:belongs];
            }else{
                [classContentRecursiveDic setValue:subDic forKey:ClassName];
            }
            classContentSubDic = [subDic mutableCopy];
            lastBelong = belongs;
        }else{
            [classContentRecursiveDic setValue:hookClass forKey:NSStringFromClass(cls)];
            classContentSubDic = [classContentRecursiveDic mutableCopy];
            classContentSubDic2 = [classContentRecursiveDic mutableCopy];
        }
    }else{
        [classContentRecursiveDic setValue:hookClass forKey:NSStringFromClass(cls)];
        classContentSubDic = [classContentRecursiveDic mutableCopy];
        classContentSubDic2 = [classContentRecursiveDic mutableCopy];
    }
    
    for (ZXHookClassPro *classPro in hookClass.classProsArr) {
        Class subCls = NSClassFromString(classPro.proType);
        if(subCls){
            if(![self isFoundationClass:subCls]){
                [self getClassContentRecursive:subCls belongs:NSStringFromClass(cls)];
            }
        }
    }
}
+(void)setDicRecursive:(NSMutableDictionary *)dic value:(id)value forKey:(NSString *)key{
    
    for (NSString *subKey in dic.allKeys) {
        id val = dic[subKey];
        if([subKey isEqualToString:key]){
            if(value){
                NSLog(@"%@--%@",key,value);
                [dic setValue:value forKey:key];
                return;
            }
        }
        if([val isKindOfClass:[NSDictionary class]]){
            [self setDicRecursive:val value:value forKey:key];
        }
    }
}
+(NSMutableDictionary *)getClassContentRecursive{
    classContentRecursiveDic = [NSMutableDictionary dictionary];
    classContentSubDic = [NSMutableDictionary dictionary];
    classContentSubDic2 = [NSMutableDictionary dictionary];
    [self getClassContentRecursive:self belongs:ClassName];
    return classContentRecursiveDic;
}
+(NSArray *)getSubClass{
    int count = objc_getClassList(NULL,0);
    NSMutableArray * array = [NSMutableArray arrayWithObject:self];
    Class *classes = (Class *)malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; i++) {
        if (self == class_getSuperclass(classes[i])) {
            [array addObject:classes[i]];
        }
    }
    free(classes);
    return array;
}
+(NSArray *)getSuperClass{
    NSMutableArray *array = [NSMutableArray array];
    Class superClass = self.superclass;
    while (true) {
        if(![superClass isFoundationClass]){
            [array addObject:superClass];
        }else{
            break;
        }
        superClass = superClass.superclass;
    }
    return array;
}
+(NSMutableArray *)getAllPropertyNames{
    
    if([[ZXHookUtil sharedInstance].allProNameList.allKeys containsObject:ClassName]){
        return [[ZXHookUtil sharedInstance].allProNameList valueForKey:ClassName];
    }
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    propertyNamesArr = [self getPropertyNames];
    if([self isFoundationClass])return propertyNamesArr;
    Class class = self.superclass;
    while (true) {
        if(![class isFoundationClass]){
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
    [[ZXHookUtil sharedInstance].allProNameList setValue:propertyNamesArr forKey:ClassName];
    return propertyNamesArr;
}

+(BOOL)isFoundationClass{
    NSString *classBundle = [NSString stringWithFormat:@"%@",[NSBundle bundleForClass:self]];
    
    return [classBundle containsString:@"</System/Library/Frameworks/Foundation.framework>"] || [classBundle containsString:@"</System/Library/Frameworks/UIKit.framework>"] || [classBundle containsString:@"</System/Library/Frameworks/CoreFoundation.framework>"];
}
+(BOOL)isFoundationClass:(Class)cls{
    NSString *classBundle = [NSString stringWithFormat:@"%@",[NSBundle bundleForClass:cls]];
    
    //return [classBundle hasSuffix:@"(loaded)"];
    return [classBundle containsString:@"</System/Library/Frameworks/Foundation.framework>"] || [classBundle containsString:@"</System/Library/Frameworks/UIKit.framework>"];
}
@end
