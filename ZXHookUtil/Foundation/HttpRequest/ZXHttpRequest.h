//
//  ZXHttpRequest.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^kGetDataEventHandler) (BOOL result, id data);
@interface ZXHttpRequest : NSObject
///post请求 传入interface
+(void)postInterface:(NSString *)interface postData:(id)postData callBack:(kGetDataEventHandler)_result;
///post请求 传入全路径
+(void)postUrl:(NSString *)urlStr postData:(id)postData callBack:(kGetDataEventHandler)_result;
///get请求 传入interface
+(void)getInterface:(NSString *)interface callBack:(kGetDataEventHandler)_result;
///get请求 传入全路径
+(void)getUrl:(NSString *)urlStr callBack:(kGetDataEventHandler)_result;
@end
