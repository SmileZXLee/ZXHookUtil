//
//  ZXBaseGlobalData.m
//  ZXBaseTableViewDemo
//
//  Created by 李兆祥 on 2019/2/15.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXBaseGlobalData.h"

@implementation ZXBaseGlobalData
+ (instancetype)shareInstance{
    static ZXBaseGlobalData * s_instance_dj_singleton = nil ;
    if (s_instance_dj_singleton == nil) {
        s_instance_dj_singleton = [[ZXBaseGlobalData alloc] init];
    }
    return (ZXBaseGlobalData *)s_instance_dj_singleton;
}

-(NSMutableDictionary *)allProNameList{
    if(!_allProNameList){
        _allProNameList = [NSMutableDictionary dictionary];
    }
    return _allProNameList;
}
@end
