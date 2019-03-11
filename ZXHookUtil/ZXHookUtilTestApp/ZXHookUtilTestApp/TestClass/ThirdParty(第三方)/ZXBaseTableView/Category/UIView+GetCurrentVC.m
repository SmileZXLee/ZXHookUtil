//
//  UIView+GetCurrentVC.m
//  ZXBaseTableViewDemo
//
//  Created by 李兆祥 on 2018/8/24.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import "UIView+GetCurrentVC.h"

@implementation UIView (GetCurrentVC)
- (UIViewController *)getCurrentVC{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
