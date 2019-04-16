//
//  ZXMethodLog.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/18.
//  Copyright © 2019 李兆祥. All rights reserved.
//  基于ANYMethodLog https://github.com/qhd/ANYMethodLog.git

#import "ZXMethodLog.h"
#import "ZXDataHandle.h"
#import <UIKit/UIKit.h>
#import "ANYMethodLog.h"
#import <mach/mach_time.h>
#import "NSString+ZXHookRegular.h"
#import "NSObject+ZXHookClassUtil.h"
@implementation ZXMethodLog

#define ZXHookMethodLog(FORMAT, ...) {\
NSCalendar *calendar = [NSCalendar currentCalendar];\
NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |NSCalendarUnitNanosecond;\
NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];\
NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%08ld",(long)dateComponent.hour, (long)dateComponent.minute, (long)dateComponent.second, (long)dateComponent.nanosecond];\
fprintf(stderr,"[ZXMethodLog][%s] %s\n",[timeStr UTF8String], [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}
+(instancetype)sharedInstance{
    static ZXMethodLog *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}
+(NSDictionary *)getTypeMapperDic{
    static NSDictionary *typeMapperDic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeMapperDic = @{[NSString stringWithUTF8String:@encode(char)] : @"(char)",
                 [NSString stringWithUTF8String:@encode(int)] : @"(int)",
                 [NSString stringWithUTF8String:@encode(short)] : @"(short)",
                 [NSString stringWithUTF8String:@encode(long)] : @"(long)",
                 [NSString stringWithUTF8String:@encode(long long)] : @"(long long)",
                 [NSString stringWithUTF8String:@encode(unsigned char)] : @"(unsigned char))",
                 [NSString stringWithUTF8String:@encode(unsigned int)] : @"(unsigned int)",
                 [NSString stringWithUTF8String:@encode(unsigned short)] : @"(unsigned short)",
                 [NSString stringWithUTF8String:@encode(unsigned long)] : @"(unsigned long)",
                 [NSString stringWithUTF8String:@encode(unsigned long long)] : @"(unsigned long long)",
                 [NSString stringWithUTF8String:@encode(float)] : @"(float)",
                 [NSString stringWithUTF8String:@encode(double)] : @"(double)",
                 [NSString stringWithUTF8String:@encode(BOOL)] : @"(BOOL)",
                 [NSString stringWithUTF8String:@encode(void)] : @"(void)",
                 [NSString stringWithUTF8String:@encode(char *)] : @"(char *)",
                 [NSString stringWithUTF8String:@encode(id)] : @"(id)",
                 [NSString stringWithUTF8String:@encode(Class)] : @"(Class)",
                 [NSString stringWithUTF8String:@encode(SEL)] : @"(SEL)",
                 [NSString stringWithUTF8String:@encode(CGRect)] : @"(CGRect)",
                 [NSString stringWithUTF8String:@encode(CGPoint)] : @"(CGPoint)",
                 [NSString stringWithUTF8String:@encode(CGSize)] : @"(CGSize)",
                 [NSString stringWithUTF8String:@encode(CGVector)] : @"(CGVector)",
                 [NSString stringWithUTF8String:@encode(CGAffineTransform)] : @"(CGAffineTransform)",
                 [NSString stringWithUTF8String:@encode(UIOffset)] : @"(UIOffset)",
                 [NSString stringWithUTF8String:@encode(UIEdgeInsets)] : @"(UIEdgeInsets)",
                 @"@?":@"(block)"
                 };
    });
    return typeMapperDic;
}

+(NSArray *)getBlackList{
    static NSArray *blackList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blackList = @[@".cxx_destruct", @"dealloc", @"_isDeallocating", @"release", @"autorelease", @"retain", @"Retain", @"_tryRetain", @"copy", @"nsis_descriptionOfVariable:",@"respondsToSelector:", @"class", @"methodSignatureForSelector:", @"allowsWeakReference", @"retainWeakReference", @"init", @"forwardInvocation:"];
    });
    return blackList;
    
}
+(NSString *)getTypeWithOrgType:(NSString *)orgType{
    return [self getValueFromDicWithArrType:[self getTypeMapperDic] key:orgType];
}

+(id)getValueFromDicWithArrType:(NSDictionary *)dic key:(NSString *)key{
    if([dic.allKeys containsObject:key]){
        NSArray *keysArr = dic.allKeys;
        NSArray *valuesArr = dic.allValues;
        int index = 0;
        while (index < keysArr.count) {
            NSString *subKey = keysArr[index];
            if([key isEqualToString:subKey]){
                return valuesArr[index];
                break;
            }
            index++;
        }
        return key;
    }
    return key;
}
+(void)addClassesTrace:(NSArray <NSString *>*)classNames{
    for (NSString *className in classNames) {
        [self addClassTrace:className];
    }
}
+(void)addClassTrace:(NSString *)className{
    [self addClassTrace:className methodList:nil];
    
}

+(void)addClassTrace:(NSString *)className methodList:(NSArray <NSString *>*)methodList{
    [self addClassTrace:className methodList:methodList jsonClassList:nil];
}
+(void)addClassTrace:(NSString *)className jsonClassList:(NSArray *)jsonClassList{
    [self addClassTrace:className methodList:nil jsonClassList:jsonClassList];
}
+(void)addClassTrace:(NSString *)className methodList:(NSArray <NSString *>*)methodList jsonClassList:(NSArray *)jsonClassList{
    if([jsonClassList containsObject:className]){
        ZXHookMethodLog(@"转json的类名中不得包含当前hook的类名，避免循环引用，jsonClassList已被置为nil");
        jsonClassList = nil;
    }
    Class targetClass = objc_getClass([className UTF8String]);
    if(targetClass != nil){
        [ANYMethodLog logMethodWithClass:NSClassFromString(className) condition:^BOOL(SEL sel) {
            return (methodList == nil || methodList.count == 0) ? YES : [methodList containsObject:NSStringFromSelector(sel)];
        } before:^(id target, SEL sel, NSArray *args, int deep) {
            
            //[self addIndexWithClassName:className];
            NSString *selector = NSStringFromSelector(sel);
            NSMutableString *selectorString = [NSMutableString new];
            if([selector containsString:@":"]){
                NSArray *selectorArrary = [selector componentsSeparatedByString:@":"];
                selectorArrary = [selectorArrary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
                
                for (int i = 0; i < selectorArrary.count; i++) {
                    
                    NSString *argStr = [self handleObj:args[i] jsonClasses:jsonClassList];
                    if(i == selectorArrary.count - 1){
                        [selectorString appendFormat:@"%@:%@", selectorArrary[i], argStr];
                    }else{
                        [selectorString appendFormat:@"%@:%@ ", selectorArrary[i], argStr];
                    }
                    
                }
                
            }else{
                [selectorString appendString:selector];
            }
            
            NSMutableString *deepString = [NSMutableString new];
            for (int i = 0; i < deep; i++) {
                if(i == 0){
                    [deepString insertString:@"│" atIndex:0];
                }else{
                    [deepString appendString:@"│"];
                }
                [deepString appendString:@" "];
            }
            if(deepString.length){
                //[deepString appendString:[NSString stringWithFormat:@"┌%ld ",[self getIndexWithClassName:className]]];
                [deepString appendString:@"┌ "];
            }else{
                [deepString insertString:@"┌ " atIndex:0];
                //[deepString insertString:[NSString stringWithFormat:@"┌%ld ",[self getIndexWithClassName:className]] atIndex:0];
            }
            NSString *prefix = [[NSString stringWithFormat:@"%@",target]containsString:@": 0x"] ? @"-" : @"+";
            NSString *targetStr = [self handleObj:target jsonClasses:jsonClassList];
            
            //targetStr = [targetStr removeAllElements:@[@"\n",@"\r",@"\t"]];
            ZXHookMethodLog(@"%@%@[Call][%@ %@]",deepString,prefix,targetStr, selectorString);
        } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval,int deep, id retValue) {
            NSMutableString *deepString = [NSMutableString new];
            for (int i = 0; i < deep; i++) {
                
                if(i == 0){
                    [deepString insertString:@"│" atIndex:0];
                }else{
                    
                    [deepString appendString:@"│"];
                }
                [deepString appendString:@" "];
            }
            NSString *prefix = [[NSString stringWithFormat:@"%@",target]containsString:@": 0x"] ? @"-" : @"+";
            if(deepString.length){
                //[deepString insertString:@"│" atIndex:0];
                [deepString appendString:@"└ "];
                //[deepString appendString:[NSString stringWithFormat:@"└%ld ",[self getIndexWithClassName:className]]];
            }else{
                [deepString insertString:@"└ " atIndex:0];
                //[deepString insertString:[NSString stringWithFormat:@"└%ld ",[self getIndexWithClassName:className]] atIndex:0];
            }
            NSString *retValueStr = [self handleObj:retValue jsonClasses:jsonClassList];
            ZXHookMethodLog(@"%@%@[Return]%@",deepString,prefix,retValueStr);
        }];
    }else{
        ZXHookMethodLog(@"Can not find class %@", className);
    }
}
+(NSString *)handleObj:(id)obj jsonClasses:(NSArray <NSString *>*)jsonClasses{
    NSString *clsStr = NSStringFromClass([obj class]);
    if([obj isKindOfClass:[NSDictionary class]]){
//        NSString *jsonStr = [[obj zx_toJsonStr]removeAllElements:@[@"\r",@"\n",@"\t"]];
//        jsonStr = [[jsonStr stringByReplacingOccurrencesOfString:@"{  \"" withString:@"{\""]stringByReplacingOccurrencesOfString:@",  \"" withString:@",\""];
        return [NSString stringWithFormat:@"<%@: %p %@>",clsStr,obj,obj];
    }
    if([jsonClasses containsObject:clsStr]){
        
        if(obj && ![NSObject isFoundationClass:[obj class]]){
            NSString *jsonStr = [[obj zx_toJsonStr]removeAllElements:@[@"\r",@"\n",@"\t"]];
            jsonStr = [[jsonStr stringByReplacingOccurrencesOfString:@"{  \"" withString:@"{\""]stringByReplacingOccurrencesOfString:@",  \"" withString:@",\""];
            return [NSString stringWithFormat:@"<%@: %p JsonContent: %@>",clsStr,obj,jsonStr];
        }
    }
    return [NSString stringWithFormat:@"%@",obj];
}
-(NSMutableDictionary *)methodTraceDic{
    if(!_methodTraceDic){
        _methodTraceDic = [NSMutableDictionary dictionary];
    }
    return _methodTraceDic;
}

+(long)getIndexWithClassName:(NSString *)clsName{
    NSMutableDictionary *muDic = [ZXMethodLog sharedInstance].methodTraceDic;
    if([muDic.allKeys containsObject:clsName]){
        return [muDic[clsName] longValue];
    }
    return -1;
}
+(void)addIndexWithClassName:(NSString *)clsName{
    NSMutableDictionary *muDic = [ZXMethodLog sharedInstance].methodTraceDic;
    if([muDic.allKeys containsObject:clsName]){
        long orgValue = [muDic[clsName] longValue];;
        orgValue++;
        [muDic setValue:[NSNumber numberWithLong:orgValue] forKey:clsName];
    }else{
        [muDic setValue:[NSNumber numberWithLong:1] forKey:clsName];
    }
}

@end
