//
//  ZXBlockLogResult.h
//  ZXBlockLogDemo
//
//  Created by 李兆祥 on 2019/5/20.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBlockLogResult : NSObject
- (instancetype)initWithMethodSignature:(NSMethodSignature *)methodSignature;
@property (copy, readonly, nonatomic) NSString *returnDecription;
@property (strong, readonly, nonatomic) NSMutableArray *argDecriptions;
@end

NS_ASSUME_NONNULL_END
