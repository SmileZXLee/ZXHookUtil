//
//  NSObject+ZXHookClassUtil.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXHookClass.h"
@interface NSObject (ZXHookClassUtil)
+(ZXHookClass *)getClassContent;
+(NSMutableDictionary *)getClassContentRecursive;
+(NSArray *)getSubClass;
+(NSArray *)getSuperClass;
+(BOOL)isFoundationClass:(Class)cls;
+(BOOL)isFoundationClass;
@end
