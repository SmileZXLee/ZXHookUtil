//
//  ZXDataStoreCache.h
//  ZXDataHandleDemo
//
//  Created by 李兆祥 on 2019/1/28.
//  Copyright © 2019 李兆祥. All rights reserved.
//  GitHub:https://github.com/SmileZXLee/ZXDataHandle

#import <Foundation/Foundation.h>
#define ZXDocPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

NS_ASSUME_NONNULL_BEGIN

@interface ZXDataStoreCache : NSObject
///将数据写入用户偏好
+(void)saveObj:(id)obj forKey:(NSString *)key;
///从用户偏好设置中读取数据
+(instancetype)readObjForKey:(NSString *)key;
///#pragma mark 归档存储数据
+(void)arcObj:(id)obj pathComponent:(NSString *)pathComponent;
///读档读取数据
+(instancetype)unArcObjPathComponent:(NSString *)pathComponent;
@end

NS_ASSUME_NONNULL_END
