//
//  EncryptionTool.m
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "EncryptionTool.h"
#import "CocoaSecurity.h"
#import <CommonCrypto/CommonDigest.h>
@implementation EncryptionTool
+(NSString *)aesEncrypt:(NSString *)data key:(NSString *)key{
    CocoaSecurityResult *res = [CocoaSecurity aesEncrypt:data key:key];
    return res.base64;
}

+(NSString *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key{
    CocoaSecurityResult *res = [CocoaSecurity aesDecryptWithBase64:data key:key];
    return res.utf8String;
}
+ (NSString *)md5Hex:(NSString *)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end
