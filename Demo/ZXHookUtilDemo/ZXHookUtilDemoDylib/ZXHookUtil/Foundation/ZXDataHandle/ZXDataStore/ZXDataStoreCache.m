//
//  ZXDataStoreCache.m
//  ZXDataHandleDemo
//
//  Created by 李兆祥 on 2019/1/28.
//  Copyright © 2019 李兆祥. All rights reserved.
//  GitHub:https://github.com/SmileZXLee/ZXDataHandle

#import "ZXDataStoreCache.h"
#import "ZXDataHandle.h"
@implementation ZXDataStoreCache

#pragma mark 将数据写入用户偏好
+(void)saveObj:(id)obj forKey:(NSString *)key{
    if(![ZXDataType isFoudationClass:obj]){
        obj= [obj zx_toDic];
    }
    if([obj isKindOfClass:[NSArray class]]){
        NSMutableArray *resArr = [NSMutableArray array];
        for (id subObj in obj) {
            if(![ZXDataType isFoudationClass:subObj]){
                [resArr addObject:[subObj zx_toDic]];
            }else{
                [resArr addObject:subObj];
            }
        }
        obj = [resArr mutableCopy];
    }
    [[NSUserDefaults standardUserDefaults]setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 从用户偏好设置中读取数据
+(instancetype)readObjForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

#pragma mark 归档存储数据
+(void)arcObj:(id)obj pathComponent:(NSString *)pathComponent{
    if(![ZXDataType isFoudationClass:obj] && obj){
        if(!([obj respondsToSelector:@selector(encodeWithCoder:)] && [obj respondsToSelector:@selector(initWithCoder:)])){
            ZXDataHandleLog(@"归档失败！对象%@未实现encodeWithCoder:或initWithCoder:",obj);
            return;
        }
    }
    [NSKeyedArchiver archiveRootObject:obj toFile:[ZXDocPath stringByAppendingPathComponent:pathComponent]];
}

#pragma mark 读档读取数据
+(instancetype)unArcObjPathComponent:(NSString *)pathComponent{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[ZXDocPath stringByAppendingPathComponent:pathComponent]];
}
@end
