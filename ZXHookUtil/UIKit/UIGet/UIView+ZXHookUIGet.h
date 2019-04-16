//
//  UIView+ZXHookUIGet.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHookUIGet.h"
@interface UIView (ZXHookUIGet)
///获取Tfs
-(NSMutableArray *)getTfs;
///根据类型获取UI
-(NSMutableArray *)getUIWithType:(UIType)type;
///根据占位符获取Tf
-(UITextField *)getTfWithPlaceHolder:(NSString *)placeHolder;
///根据颜色和类型获取UI
-(NSMutableArray *)getUIWithColor:(UIColor *)color type:(UIType)type;
///根据高度和类型获取UI
-(NSMutableArray *)getUIWithHeight:(CGFloat)height type:(UIType)type;
///根据Frame和类型获取UI
-(NSMutableArray *)getUIWithFrame:(CGRect)frame type:(UIType)type;
///根据Text和类型获取UI
-(NSMutableArray *)getUIWithText:(NSString *)text type:(UIType)type;
@end
