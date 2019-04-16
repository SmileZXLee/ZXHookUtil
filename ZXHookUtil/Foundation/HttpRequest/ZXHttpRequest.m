//
//  ZXHttpRequest.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXHttpRequest.h"
#define TimeOutSec 10
#define kMainUrl @"http://www.baidu.com"
@implementation ZXHttpRequest
#pragma mark POST请求
+(void)postInterface:(NSString *)interface postData:(id)postData callBack:(kGetDataEventHandler)_result{
    [self baseInterface:interface postData:postData callBack:_result];
}
+(void)postUrl:(NSString *)urlStr postData:(id)postData callBack:(kGetDataEventHandler)_result{
    [self baseUrl:urlStr postData:postData callBack:_result];
}
#pragma mark GET请求
+(void)getInterface:(NSString *)interface callBack:(kGetDataEventHandler)_result{
    [self baseInterface:interface postData:nil callBack:_result];
}
+(void)getUrl:(NSString *)urlStr callBack:(kGetDataEventHandler)_result{
    [self baseUrl:urlStr postData:nil callBack:_result];
}
#pragma mark - private
+(void)baseInterface:(NSString *)interface postData:(id)postData callBack:(kGetDataEventHandler)_result{
    [self baseUrl:[NSString stringWithFormat:@"%@/%@",kMainUrl,interface] postData:postData callBack:_result];
}
+(void)baseUrl:(NSString *)urlStr postData:(id)postData callBack:(kGetDataEventHandler)_result{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *mr = [NSMutableURLRequest requestWithURL:url];
    if(postData){
        mr.HTTPMethod = @"POST";
        if([postData isKindOfClass:[NSDictionary class]]){
            mr.HTTPBody = [[self getJsonStrWithDic:postData] dataUsingEncoding:NSUTF8StringEncoding];
        }else{
            mr.HTTPBody = [postData dataUsingEncoding:NSUTF8StringEncoding];
        }
        [mr setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }else{
        mr.HTTPMethod = @"GET";
    }
    mr.timeoutInterval = TimeOutSec;
    [NSURLConnection sendAsynchronousRequest:mr queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {
            _result(NO,connectionError);
        }else{
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *reData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            _result(YES,[NSJSONSerialization JSONObjectWithData:reData options:NSJSONReadingMutableLeaves error:nil]);
        }
    }];
}
#pragma mark 字典转json
+(NSString *)getJsonStrWithDic:(NSDictionary *)dic{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end
