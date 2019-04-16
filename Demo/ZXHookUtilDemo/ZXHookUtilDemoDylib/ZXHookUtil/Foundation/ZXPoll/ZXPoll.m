//
//  ZXPoll.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/9.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXPoll.h"
@interface ZXPoll()
@property(nonatomic,strong)dispatch_source_t timer;
@end
@implementation ZXPoll
-(void)addTimerWithSec:(long)sec callBack:(pollPerStepBlock)pollPerStepBlock{
    self.run = YES;
    if(self.timer){
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, sec * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if(self.run){
            pollPerStepBlock();
        }
    });
    dispatch_resume(timer);
    self.timer = timer;
}
-(void)removeTimer{
    if(self.timer){
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}
@end
