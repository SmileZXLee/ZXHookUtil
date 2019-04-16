//
//  EncryptionTool.h
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EncryptionTool : NSObject

+(NSString *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key;
+(NSString *)aesEncrypt:(NSString *)data key:(NSString *)key;
+ (NSString *)md5Hex:(NSString *)input;
@end

NS_ASSUME_NONNULL_END
