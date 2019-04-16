//
//  ZXDataHandle.h
//  ZXHookUtilDemo
//
//  Created by 李兆祥 on 2019/3/9.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#ifdef DEBUG
#define ZXDataHandleLog(FORMAT, ...) fprintf(stderr,"------------------------- ZXDataHandleLog -------------------------\n编译时间:%s\n文件名:%s\n方法名:%s\n行号:%d\n打印信息:%s\n\n", __TIME__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__,__LINE__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define ZXDataHandleLog(FORMAT, ...) nil
#endif
#import "ZXDataType.h"
#import "ZXDataConvert.h"
#import "NSDictionary+ZXSafetySet.h"
#import "NSMutableArray+ZXSafetySet.h"
#import "NSString+ZXDataConvert.h"
#import "NSString+ZXRegular.h"
#import "NSObject+ZXToModel.h"
#import "NSObject+ZXToDic.h"
#import "NSObject+ZXToJson.h"
#import "NSObject+ZXSafetySet.h"
#import "NSObject+ZXDataConvertRule.h"
#import "ZXDecimalNumberTool.h"

#import "NSObject+ZXGetProperty.h"
#import "ZXClassArchived.h"
#import "ZXDataStoreCache.h"
#import "ZXDataStoreSQlite.h"
#import "NSObject+ZXSQliteHandle.h"



