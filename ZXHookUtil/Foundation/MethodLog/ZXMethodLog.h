//
//  ZXMethodLog.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/18.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface ZXMethodLog : NSObject
+(instancetype)sharedInstance;
+(NSDictionary *)getTypeMapperDic;
+(NSString *)getTypeWithOrgType:(NSString *)orgType;
+(id)getValueFromDicWithArrType:(NSDictionary *)dic key:(NSString *)key;
+(NSArray *)getBlackList;

+(void)addClassTrace:(NSString *)className;
+(void)addClassTrace:(NSString *)className methodList:(NSArray <NSString *>*)methodList;
+(void)addClassTrace:(NSString *)className methodList:(NSArray <NSString *>*)methodList jsonClassList:(NSArray <NSString *>*)jsonClassList;
+(void)addClassTrace:(NSString *)className jsonClassList:(NSArray *)jsonClassList;
+(void)addClassesTrace:(NSArray <NSString *>*)classNames;

@property(nonatomic, strong)NSMutableDictionary *methodTraceDic;
@end
