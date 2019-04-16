//
//  ZXHoolClassPro.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface ZXHookClassPro : NSObject
@property(nonatomic, copy)NSString *proName;
@property(nonatomic, copy)NSString *proType;
@property(nonatomic, copy)NSString *proTypeOrg;
@property(nonatomic, assign)objc_property_t pro;
@end
