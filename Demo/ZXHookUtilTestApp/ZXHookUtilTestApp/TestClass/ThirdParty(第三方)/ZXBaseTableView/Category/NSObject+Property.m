//
//  NSObject+Property.m
//  ZXBaseTableViewDemo
//
//  Created by 李兆祥 on 2018/8/27.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>
@implementation NSObject (Property)
-(void)setCellHRunTime:(NSNumber *)cellHRunTime{
    objc_setAssociatedObject(self, @"cellHRunTime",cellHRunTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)cellHRunTime
{
    return objc_getAssociatedObject(self, @"cellHRunTime");
}
@end
