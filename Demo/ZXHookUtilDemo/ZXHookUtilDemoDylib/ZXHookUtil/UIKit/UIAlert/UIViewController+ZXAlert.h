//
//  UIViewController+ZXAlert.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/11.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZXAlert)
-(void)showAlert:(NSString *)text;
-(void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg;
@end
