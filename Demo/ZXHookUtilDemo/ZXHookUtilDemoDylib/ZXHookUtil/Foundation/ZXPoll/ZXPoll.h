//
//  ZXPoll.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/9.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^pollPerStepBlock)(void);
@interface ZXPoll : NSObject
@property(nonatomic,assign)BOOL run;
-(void)addTimerWithSec:(long)sec callBack:(pollPerStepBlock)pollPerStepBlock;
-(void)removeTimer;
@end
