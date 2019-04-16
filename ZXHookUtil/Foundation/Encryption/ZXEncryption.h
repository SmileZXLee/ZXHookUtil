//
//  ZXEncryption.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/11.
//  Copyright © 2019 李兆祥. All rights reserved.
//  From https://github.com/kelp404/CocoaSecurity

#import <Foundation/Foundation.h>

@interface ZXEncryption : NSObject
+(NSString *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key;
+(NSString *)aesEncrypt:(NSString *)data key:(NSString *)key;
+(NSString *)md5:(NSString *)hashString;
@end
