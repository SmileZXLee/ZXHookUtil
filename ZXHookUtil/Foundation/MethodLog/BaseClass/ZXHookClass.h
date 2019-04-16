//
//  ZXHookClass.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZXHookClassPro.h"
#import "ZXHookClassMethod.h"
@interface ZXHookClass : NSObject
@property(nonatomic, strong)NSMutableArray<ZXHookClassPro *> *classProsArr;
@property(nonatomic, strong)NSMutableArray<ZXHookClassMethod *> *classMethodsArr;
@end
