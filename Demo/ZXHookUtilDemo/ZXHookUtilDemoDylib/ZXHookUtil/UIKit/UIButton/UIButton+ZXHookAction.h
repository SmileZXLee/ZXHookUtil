//
//  UIButton+ZXHookEvent.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/18.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZXHookAction)
///获取按钮所有点击事件方法
-(NSMutableDictionary *)getAllTouchUpAction;
///直接调用按钮的所有点击事件方法
-(void)callBtnActions;
@end
