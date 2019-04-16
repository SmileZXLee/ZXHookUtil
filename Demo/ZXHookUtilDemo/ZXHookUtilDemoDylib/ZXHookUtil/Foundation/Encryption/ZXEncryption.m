//
//  ZXEncryption.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/11.
//  Copyright © 2019 李兆祥. All rights reserved.
//  From https://github.com/kelp404/CocoaSecurity

#import "ZXEncryption.h"
#import "CocoaSecurity.h"
@implementation ZXEncryption
+(NSString *)aesEncrypt:(NSString *)data key:(NSString *)key{
    CocoaSecurityResult *res = [CocoaSecurity aesEncrypt:data key:key];
    return res.base64;
}
+(NSString *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key{
    CocoaSecurityResult *res = [CocoaSecurity aesDecryptWithBase64:data key:key];
    return res.utf8String;
}
+(NSString *)md5:(NSString *)hashString{
    CocoaSecurityResult *res = [CocoaSecurity md5:hashString];
    return res.utf8String;
}

@end
