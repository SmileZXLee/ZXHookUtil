//
//  HttpRequest.m
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "HttpRequest.h"
#import "EncryptionTool.h"
#define TimeOutSec 10
#define kMainUrl @"https://www.baidu.com"
@implementation HttpRequest
#pragma mark POST请求
+(void)postInterface:(NSString *)interface postData:(id)postData callBack:(kGetDataEventHandler)_result{
    [self baseInterface:interface postData:postData callBack:_result];
}
#pragma mark GET请求
+(void)getInterface:(NSString *)interface callBack:(kGetDataEventHandler)_result{
    [self baseInterface:interface postData:nil callBack:_result];
}
#pragma mark 基础请求
+(void)baseInterface:(NSString *)interface postData:(id)postData callBack:(kGetDataEventHandler)_result{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kMainUrl,interface];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *mr = [NSMutableURLRequest requestWithURL:url];
    if(postData){
        mr.HTTPMethod = @"POST";
        NSMutableDictionary *muDic = [postData mutableCopy];
        muDic[@"timestamp"] = [self getTimeStamp];
        NSString *sign = [self getSignWithDic:muDic interface:interface];
        muDic[@"sign"] = sign;
        NSString *postJson = [self getJsonStrWithDic:muDic];
        mr.HTTPBody = [postJson dataUsingEncoding:NSUTF8StringEncoding];
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
#pragma mark json转字典
+ (NSDictionary *)getDicWithStr:(NSString *)str {
    if (str == nil) {
        return @{};
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dic;
}
+(NSString *)getSignWithDic:(NSDictionary *)dic interface:(NSString *)interface{
    NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSString *sumStr = @"";
    for (NSString *key in sortedKeys) {
        if(![key isEqualToString:@"timestamp"]){
            NSObject *value = [dic valueForKey:key];
            NSString *valueStr = [NSString stringWithFormat:@"%@",value];
            sumStr = [sumStr stringByAppendingString:[NSString stringWithFormat:@"%@%@",key,valueStr]];
        }
    }
    sumStr = [NSString stringWithFormat:@"TestAppTest%@%@%@ csjnjksadh",interface,sumStr,dic[@"timestamp"]];
    NSString *sign = [EncryptionTool md5Hex:[NSString stringWithFormat:@"%@",sumStr]];
    NSLog(@"%@",sign);
    return sign;
}
+(NSString *)getTimeStamp{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}
@end
