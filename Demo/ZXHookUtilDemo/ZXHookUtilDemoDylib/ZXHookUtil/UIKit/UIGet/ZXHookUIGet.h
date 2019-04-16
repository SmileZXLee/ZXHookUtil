//
//  ZXHookUIGet.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, UIType) {
    UITypeView = 0,
    UITypeTextField,
    UITypeLabel,
    UITypeButton,
    UITypeImageView
};
@interface ZXHookUIGet : NSObject
+ (instancetype)sharedInstance;
///获取父控件对应类型UI recursive：是否递归 type：查找的UIType类型
-(NSMutableArray *)getUIInView:(UIView *)view type:(UIType)type recursive:(BOOL)recursive;
///获取父控件对应类型UI recursive：是否递归 cls：查找的类名
-(NSMutableArray *)getUIInView:(UIView *)view class:(Class)cls recursive:(BOOL)recursive;
///根据placeHolder从父控件中获取UITextField
-(UITextField *)getTfInView:(UIView *)view placeHolder:(NSString *)placeHolder;
///根据颜色获取控件
-(NSMutableArray *)getUIInView:(UIView *)view color:(UIColor *)color type:(UIType)type;
///根据frame获取控件
-(NSMutableArray *)getUIInView:(UIView *)view frame:(CGRect)frame type:(UIType)type;
///根据高度获取控件
-(NSMutableArray *)getUIInView:(UIView *)view height:(CGFloat)height type:(UIType)type;
///根据显示内容获取控件
-(NSMutableArray *)getUIInView:(UIView *)view text:(NSString *)text type:(UIType)type;
///获取keyWindow
+(UIWindow *)getKeyWindow;
///获取根控制器
+(UIViewController *)getRootVC;
///获取最前面的控制器
+(UIViewController *)getTopVC;
@end
