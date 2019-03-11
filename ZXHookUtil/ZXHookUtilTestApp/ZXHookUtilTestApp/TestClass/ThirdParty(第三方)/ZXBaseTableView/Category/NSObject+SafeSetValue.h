//
//  NSObject+SafeSetValue.h
//  ZXBaseTableView
//
//  Created by 李兆祥 on 2018/8/20.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeSetValue)
-(NSMutableArray *)getPropertyNames;
-(NSMutableArray *)getAllPropertyNames;
-(void)safeSetValue:(id)value forKey:(NSString *)key;
-(void)safeSetValue:(id)value forKeyPath:(NSString *)key;
-(instancetype)safeValueForKey:(NSString *)key;
-(instancetype)safeValueForKeyPath:(NSString *)key;
@end
