//
//  UIButton+ZXHookEvent.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/18.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "UIButton+ZXHookAction.h"

@implementation UIButton (ZXHookAction)
-(NSMutableDictionary *)getAllTouchUpAction{
    NSMutableDictionary *allTouchUpAction = [NSMutableDictionary dictionary];
    NSArray *allTargets = self.allTargets.allObjects;
    for (id target in allTargets) {
        NSString *targetClassName = NSStringFromClass([target class]);
        NSArray *action =  [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        [allTouchUpAction setValue:action forKey:targetClassName];
    }
    return allTouchUpAction;
}
-(void)callBtnActions{
    NSArray *allTargets = self.allTargets.allObjects;
    for (id target in allTargets) {
        NSArray *actions =  [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString *action in actions) {
            [target performSelector:NSSelectorFromString(action) withObject:self afterDelay:0];
        }
    }
}

@end
