//
//  ZXBlockLog.h
//  ZXBlockLogDemo
//
//  Created by 李兆祥 on 2019/5/20.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXBlockLogResult.h"
NS_ASSUME_NONNULL_BEGIN
#define ZXBlockLog(block) [ZXBlockLog logWithBlock:block].description
@interface ZXBlockLog : NSObject
+ (ZXBlockLogResult *)logWithBlock:(id)block;
@end

NS_ASSUME_NONNULL_END
