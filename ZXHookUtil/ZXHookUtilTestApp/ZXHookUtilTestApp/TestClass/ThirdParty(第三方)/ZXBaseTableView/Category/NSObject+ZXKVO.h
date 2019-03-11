//
//  NSObject+ZXKVO.h
//  ZXBaseTableView
//
//  Created by 李兆祥 on 2018/8/22.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^obsResultHandler) (id newData, id oldData,id owner);
@interface NSObject (ZXKVO)
-(void)obsKey:(NSString *)key handler:(obsResultHandler)handler;
-(void)removeObsKey:(NSString *)key;
@end
