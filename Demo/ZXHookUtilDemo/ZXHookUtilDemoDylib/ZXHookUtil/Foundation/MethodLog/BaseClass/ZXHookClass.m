//
//  ZXHookClass.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXHookClass.h"

@implementation ZXHookClass
-(instancetype)init{
    if(self = [super init]){
        self.classProsArr = [NSMutableArray array];
        self.classMethodsArr = [NSMutableArray array];
    }
    return self;
}
-(NSMutableArray<ZXHookClassPro *> *)classProsArr{
    if(!_classProsArr){
        _classProsArr = [NSMutableArray array];
    }
    return _classProsArr;
}
-(NSMutableArray<ZXHookClassMethod *> *)classMethodsArr{
    if(!_classMethodsArr){
        _classMethodsArr = [NSMutableArray array];
    }
    return _classMethodsArr;
}
@end
