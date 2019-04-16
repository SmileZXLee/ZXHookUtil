//
//  ZXCodeFloor.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//  书写业务代码

#import "ZXCodeFloor.h"

@implementation ZXCodeFloor
+(void)initAction{
    //追踪类LoginVC的方法调用，并将方法参数中包含的LoginModel类转为Json打印输出
    [ZXHookUtil addClassTrace:@"LoginVC" jsonClassList:@[@"LoginModel"]];
    [ZXHookUtil addClassTrace:@"HttpRequest"];
    [ZXHookUtil addClassTrace:@"EncryptionTool"];
}
+(void)handleObj:(id)obj{
    
}
@end
