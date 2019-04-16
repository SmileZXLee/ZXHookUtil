//
//  ZXBaseGlobalData.h
//  ZXBaseTableViewDemo
//
//  Created by 李兆祥 on 2019/2/15.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBaseGlobalData : NSObject
+ (instancetype)shareInstance;
@property(nonatomic, strong)NSMutableDictionary *allProNameList;
@end

NS_ASSUME_NONNULL_END
