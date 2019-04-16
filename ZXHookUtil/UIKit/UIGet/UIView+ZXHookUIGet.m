//
//  UIView+ZXHookUIGet.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "UIView+ZXHookUIGet.h"
@implementation UIView (ZXHookUIGet)
-(NSMutableArray *)getUIWithType:(UIType)type{
    ZXHookUIGet *uiget = [ZXHookUIGet sharedInstance];
    return [uiget getUIInView:self type:type recursive:YES];
}
-(NSMutableArray *)getUIWithClass:(Class)cls{
    ZXHookUIGet *uiget = [ZXHookUIGet sharedInstance];
    return [uiget getUIInView:self class:cls recursive:YES];
}
-(UITextField *)getTfWithPlaceHolder:(NSString *)placeHolder{
    ZXHookUIGet *uiget = [ZXHookUIGet sharedInstance];
    return [uiget getTfInView:self placeHolder:placeHolder];
}
-(NSMutableArray *)getTfs{
    return [self getUIWithType:UITypeTextField];
}
-(NSMutableArray *)getUIWithColor:(UIColor *)color type:(UIType)type{
    ZXHookUIGet *uiget = [ZXHookUIGet sharedInstance];
    return [uiget getUIInView:self color:color type:type];
}
-(NSMutableArray *)getUIWithHeight:(CGFloat)height type:(UIType)type{
    ZXHookUIGet *uiget = [ZXHookUIGet sharedInstance];
    return [uiget getUIInView:self height:height type:type];
}
-(NSMutableArray *)getUIWithFrame:(CGRect)frame type:(UIType)type{
    ZXHookUIGet *uiget = [ZXHookUIGet sharedInstance];
    return [uiget getUIInView:self frame:frame type:type];
}
-(NSMutableArray *)getUIWithText:(NSString *)text type:(UIType)type{
    ZXHookUIGet *uiget = [ZXHookUIGet sharedInstance];
    return [uiget getUIInView:self text:text type:type];
}
@end
