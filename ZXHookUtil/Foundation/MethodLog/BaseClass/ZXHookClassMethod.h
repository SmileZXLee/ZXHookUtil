//
//  ZXHoolClassMethod.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
typedef NS_OPTIONS(NSUInteger, ZXMethodType) {
    ZXMethodTypeInstance = 0,
    ZXMethodTypeStatic,
};
@interface ZXHookClassMethod : NSObject
-(instancetype)initWithMethod:(Method)method;
@property(nonatomic, copy,readonly)NSString *methodName;
@property(nonatomic, copy,readonly)NSString *methodDescription;
@property(nonatomic, copy,readonly)NSString *methodReturnType;
@property(nonatomic, assign)ZXMethodType methodType;
@property(nonatomic, assign,readonly)Method method;
@end
