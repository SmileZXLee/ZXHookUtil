//
//  NSObject+ZXKVO.m
//  ZXBaseTableView
//
//  Created by 李兆祥 on 2018/8/22.
//  Copyright © 2018年 李兆祥. All rights reserved.
//  Github地址：https://github.com/SmileZXLee/ZXBaseTableView

#import "NSObject+ZXKVO.h"

@implementation NSObject (ZXKVO)
-(void)obsKey:(NSString *)key handler:(obsResultHandler)handler{
    [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:CFBridgingRetain([handler copy])];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if(object == self){
        obsResultHandler handler = (__bridge obsResultHandler)context;
        handler(change[@"new"],change[@"old"],self);
    }
}
-(void)removeObsKey:(NSString *)key{
    [self removeObserver:self forKeyPath:key];
}

@end
