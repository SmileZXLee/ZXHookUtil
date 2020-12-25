//
//  ZXHookUIGet.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXHookUIGet.h"
@interface ZXHookUIGet()
@property(nonatomic,strong)NSMutableArray *resultUIArr;
@property(nonatomic,strong)NSArray *uiClassArr;
@end
@implementation ZXHookUIGet
+(instancetype)sharedInstance{
    static ZXHookUIGet *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    sharedInstance.resultUIArr = [NSMutableArray array];
    sharedInstance.uiClassArr = @[[UIView class],[UITextField class],[UILabel class],[UIButton class],[UIImageView class]];
    return sharedInstance;
}
-(NSMutableArray *)getUIInView:(UIView *)view type:(UIType)type recursive:(BOOL)recursive{
    return [self getUIInView:view class:(Class)_uiClassArr[type] recursive:recursive];
}
-(NSMutableArray *)getUIInView:(UIView *)view class:(Class)cls recursive:(BOOL)recursive{
    NSMutableArray *subViewsArr;
    if([view isKindOfClass:[UITableView class]]){
        subViewsArr = [NSMutableArray arrayWithArray:((UITableView *)view).visibleCells];
        [subViewsArr addObjectsFromArray:view.subviews];
    }else if([view isKindOfClass:[UICollectionView class]]){
        subViewsArr = [NSMutableArray arrayWithArray:((UICollectionView *)view).visibleCells];
        [subViewsArr addObjectsFromArray:view.subviews];
    }else{
        subViewsArr = [NSMutableArray arrayWithArray:view.subviews];
    }
    for (UIView *subView in subViewsArr) {
        if([subView isKindOfClass:cls]){
            [_resultUIArr addObject:subView];
        }
        if(recursive){
            if(subView.subviews.count){
                [self getUIInView:subView class:cls recursive:recursive];
            }
        }
    }
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:_resultUIArr];
    NSMutableArray *resultArr = [set.array mutableCopy];
    return resultArr;
}

-(UITextField *)getTfInView:(UIView *)view placeHolder:(NSString *)placeHolder{
    UITextField *resultTf;
    NSArray *resultTfArr = [self getUIInView:view type:UITypeTextField recursive:YES];
    for (UITextField *tf in resultTfArr) {
        if([tf.placeholder isEqualToString:placeHolder]){
            resultTf = tf;
        }
    }
    
    return resultTf;
}

-(NSMutableArray *)getUIInView:(UIView *)view color:(UIColor *)color type:(UIType)type{
    NSMutableArray *uiArr = [self getUIInView:view type:type recursive:YES];
    NSMutableArray *matchArr = [NSMutableArray array];
    for (UIView *subView in uiArr) {
        if((CGColorEqualToColor(subView.backgroundColor.CGColor, color.CGColor))){
            [matchArr addObject:subView];
        }
    }
    return matchArr;
}

-(NSMutableArray *)getUIInView:(UIView *)view frame:(CGRect)frame type:(UIType)type{
    NSMutableArray *uiArr = [self getUIInView:view type:type recursive:YES];
    NSMutableArray *matchArr = [NSMutableArray array];
    for (UIView *subView in uiArr) {
        if(CGRectEqualToRect(subView.frame,frame)){
            [matchArr addObject:subView];
        }
    }
    return matchArr;
}
-(NSMutableArray *)getUIInView:(UIView *)view height:(CGFloat)height type:(UIType)type{
    NSMutableArray *uiArr = [self getUIInView:view type:type recursive:YES];
    NSMutableArray *matchArr = [NSMutableArray array];
    for (UIView *subView in uiArr) {
        if(ABS(subView.frame.size.height - height) < 1){
            [matchArr addObject:subView];
        }
    }
    return matchArr;
}
-(NSMutableArray *)getUIInView:(UIView *)view text:(NSString *)text type:(UIType)type{
    NSMutableArray *uiArr = [self getUIInView:view type:type recursive:YES];
    NSMutableArray *matchArr = [NSMutableArray array];
    for (UIView *subV in uiArr) {
        if([subV isKindOfClass:[UILabel class]]){
            if([((UILabel *)subV).text isEqualToString:text]){
                [matchArr addObject:subV];
            }
        }
        if([subV isKindOfClass:[UITextField class]]){
            if([((UITextField *)subV).text isEqualToString:text] || [((UITextField *)subV).placeholder isEqualToString:text]){
                [matchArr addObject:subV];
            }
        }
        if([subV isKindOfClass:[UITextView class]]){
            if([((UITextView *)subV).text isEqualToString:text]){
                [matchArr addObject:subV];
            }
        }
        if([subV isKindOfClass:[UIButton class]]){
            if([((UIButton *)subV).currentTitle isEqualToString:text]){
                [matchArr addObject:subV];
            }
        }
    }
    return matchArr;
}
+(UIViewController *)getTopVC{
    return [self getTopVCRecursive:[self getRootVC]];
}
+(UIViewController *)getTopVCRecursive:(UIViewController *)vc{
    if(vc.presentedViewController){
        return [self getTopVCRecursive:(UIViewController *)vc.presentedViewController];
    }else if([vc isKindOfClass:[UITabBarController class]]){
        return [self getTopVCRecursive:((UITabBarController *)vc).selectedViewController];
    }else if([vc isKindOfClass:[UINavigationController class]]){
        return [self getTopVCRecursive:((UINavigationController *)vc).visibleViewController];
    }else{
        
        int count = (int)vc.childViewControllers.count;
        for (int i = count - 1; i >= 0; i--) {
            UIViewController *childVc = vc.childViewControllers[i];
            if (childVc && childVc.view.window) {
                vc = [self getTopVCRecursive:childVc];
                break;
            }
        }
        return vc;
    }
    
}
+(UIWindow *)getKeyWindow{
    return ([UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject);
}
+(UIViewController *)getRootVC{
    return [self getKeyWindow].rootViewController;
}

@end

