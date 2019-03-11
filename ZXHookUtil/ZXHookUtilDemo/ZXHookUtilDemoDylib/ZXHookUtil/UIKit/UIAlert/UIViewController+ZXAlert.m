//
//  UIViewController+ZXAlert.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/11.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "UIViewController+ZXAlert.h"

@implementation UIViewController (ZXAlert)
-(void)showAlert:(NSString *)text{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"提示" message:text preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style: UIAlertActionStyleCancel handler: nil];
    [alert addAction:okAction];
    [self presentViewController: alert animated: YES completion: nil];
}
-(void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title message:msg preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style: UIAlertActionStyleCancel handler: nil];
    [alert addAction:okAction];
    [self presentViewController: alert animated: YES completion: nil];
}

@end
