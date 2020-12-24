//
//  ZXCodeFloor.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//  书写业务代码
//  Github：https://github.com/SmileZXLee/ZXHookUtil

#import "ZXCodeFloor.h"
@implementation ZXCodeFloor
+(void)initAction{
    //追踪类LoginVC的方法调用，并将方法参数中包含的LoginModel类转为Json打印输出
    [ZXHookUtil addClassTrace:@"LoginVC" jsonClassList:@[@"LoginModel"]];
    [ZXHookUtil addClassTrace:@"HttpRequest"];
    [ZXHookUtil addClassTrace:@"EncryptionTool"];
    //打印block内部参数
    //ZXBlockLog(block);
    //更多功能查阅文件ZXHookUtil.h或访问https://github.com/SmileZXLee/ZXHookUtil
}
+(void)handleObj:(id)obj{
    
}
@end
