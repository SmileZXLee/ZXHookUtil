//
//  UIButton+ZXAddAction.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/10.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ZXActionBlock)(UIButton *button);
@interface UIButton (ZXAddAction)
-(void)addClickAction:(ZXActionBlock)callBack;
@end
