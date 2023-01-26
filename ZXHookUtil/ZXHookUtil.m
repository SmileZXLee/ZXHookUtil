//
//  ZXHookUtil.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/2/16.
//  Copyright © 2019 李兆祥. All rights reserved.
//  工具集合类
//  Github：https://github.com/SmileZXLee/ZXHookUtil

#import "ZXHookUtil.h"
#import "NSObject+ZXHookClassUtil.h"
@implementation ZXHookUtil

+(instancetype)sharedInstance{
    static ZXHookUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

#pragma mark - Foundation
#pragma mark - BaseInfo
#pragma mark 获取BundleId
+(NSString *)getBundleId{
    return [NSBundle mainBundle].bundleIdentifier;
}
#pragma mark 获取UUID
+(NSString *)getUUID{
    return  [[UIDevice currentDevice] identifierForVendor].UUIDString;
}
#pragma mark 获取App安装路径

+(NSString *)getAppPath{
    return [NSBundle mainBundle].bundlePath;
}
#pragma mark 获取App沙盒doc路径
+(NSString *)getDocPath{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}
#pragma mark 获取App沙盒Cache路径
+(NSString *)getCachesPath{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

#pragma mark - Class相关
#pragma mark 获取类的所有属性和方法
+(ZXHookClass *)getClassContent:(id)obj{
    Class cls = obj;
    if([obj isKindOfClass:[NSString class]]){
        cls = NSClassFromString(obj);
    }else if([obj isKindOfClass:[NSObject class]]){
        cls = [obj class];
    }
    return [cls getClassContent];
    
}
#pragma mark 获取类的所有方法描述
+(NSArray *)getClassMethodsDescription:(id)obj{
    ZXHookClass *resCls = [self getClassContent:obj];
    NSMutableArray *methodsArr = [NSMutableArray array];
    for (ZXHookClassMethod *method in resCls.classMethodsArr) {
        [methodsArr addObject:method.methodDescription];
    }
    return methodsArr;
}

#pragma mark 打印类的所有方法描述
+(void)logClassMethodsDescription:(id)obj{
    NSArray *methodsArr = [self getClassMethodsDescription:obj];
    NSLog(@"********[%@]所有方法*********",obj);
    for (NSString *methodDec in methodsArr) {
        NSLog(@"%@",methodDec);
    }
    NSLog(@"********[%@]End*********",obj);
}

#pragma mark 获取类的所有属性描述
+(NSArray *)getClassPropertiesDescription:(id)obj{
    ZXHookClass *resCls = [self getClassContent:obj];
    NSMutableArray *prosArr = [NSMutableArray array];
    for (ZXHookClassPro *pro in resCls.classProsArr) {
        [prosArr addObject:[NSString stringWithFormat:@"(%@)%@",pro.proType,pro.proName]];
    }
    return prosArr;
}
#pragma mark 打印类的所有属性描述
+(void)logClassPropertiesDescription:(id)obj{
    NSArray *prosArr = [self getClassPropertiesDescription:obj];
    NSLog(@"********[%@]所有属性*********",obj);
    for (NSString *proDec in prosArr) {
        NSLog(@"%@",proDec);
    }
    NSLog(@"********[%@]End*********",obj);
}
#pragma mark 判断是否是系统类
+(BOOL)isFoundationClass:(Class)cls{
    return [self isFoundationClass:cls];
}
#pragma mark 获取所有子类
+(NSArray *)getSubClass:(id)obj{
    Class cls = obj;
    if([obj isKindOfClass:[NSString class]]){
        cls = NSClassFromString(obj);
    }else if([obj isKindOfClass:[NSObject class]]){
        cls = [obj class];
    }
    return [cls getSubClass];
}

#pragma mark 获取所有父类
+(NSArray *)getSuperClass:(id)obj{
    Class cls = obj;
    if([obj isKindOfClass:[NSString class]]){
        cls = NSClassFromString(obj);
    }else if([obj isKindOfClass:[NSObject class]]){
        cls = [obj class];
    }
    return [cls getSuperClass];
}

#pragma mark - 数据转换
#pragma mark 任意类型转字典
+(id)toDic:(id)obj{
    return [obj zx_toDic];
}
#pragma mark 任意类型转Json字符串
+(NSString *)toJson:(id)obj{
    return [obj zx_toJsonStr];
}
#pragma mark 任意类型转keyvalue（form-data）类型
+(NSString *)tokvStr:(id)obj{
    return [obj zx_kvStr];
}
#pragma mark 任意类型转模型 cls为需要转的模型的类，orgObj为需要转的原始数据
+(id)toModel:(Class)cls orgObj:(id)orgObj{
    return [cls zx_modelWithObj:orgObj];
}
#pragma mark - 数据存储
#pragma mark 存储到UserDefaults
+(void)saveObj:(id)obj forKey:(NSString *)key{
    [ZXDataStoreCache saveObj:obj forKey:key];
}
#pragma mark 从UserDefaults中读取数据
+(id)readObjForKey:(NSString *)key{
    return [ZXDataStoreCache readObjForKey:key];
}
#pragma mark 存储到沙盒doc文件夹
+(void)arcObj:(id)obj pathComponent:pathComponent{
    [ZXDataStoreCache arcObj:obj pathComponent:pathComponent];
}
#pragma mark 从沙盒doc文件夹中读取数据
+(id)unArcObjPathComponent:(NSString *)pathComponent{
    return [ZXDataStoreCache unArcObjPathComponent:pathComponent];
}
#pragma mark 清除所有缓存数据
+(void)cleanAllData{
    [self clearUserDefaults];
    [self clearKeyChain];
    [self cleanFileWithPath:[self getDocPath]];
    [self cleanFileWithPath:[self getCachesPath]];
}
#pragma mark 清除UserDefaults数据
+(void)clearUserDefaults{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"Preferences"];
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString * filename in fileList) {
        NSString *filepath = [path stringByAppendingPathComponent:filename];
        BOOL isDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:(&isDir)];
        if (!isDir && [filename hasSuffix:@".plist"] && (![filename isEqualToString:appDomain])) {
            NSString *suitename = [filename stringByDeletingPathExtension];
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:suitename];
            [userDefaults removePersistentDomainForName:suitename];
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        }
    }
}
#pragma mark 清除KeyChain数据
+(void)clearKeyChain{
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
                                  (__bridge id)kSecMatchLimitAll, (__bridge id)kSecMatchLimit,
                                  nil];
    NSArray *secClasses = [NSArray arrayWithObjects:
                               (__bridge id)kSecClassGenericPassword,
                               (__bridge id)kSecClassInternetPassword,
                               (__bridge id)kSecClassCertificate,
                               (__bridge id)kSecClassKey,
                               (__bridge id)kSecClassIdentity,
                               nil];
    for (id secClass in secClasses) {
        [query setObject:secClass forKey:(__bridge id)kSecClass];
        CFTypeRef result = NULL;
        SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
        if (result != NULL) CFRelease(result);
        NSDictionary *spec = @{(__bridge id)kSecClass: secClass};
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
}

#pragma mark 根据文件路径清除文件
+(void)cleanFileWithPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

#pragma mark - 添加方法跟踪
+(void)addClassTrace:(NSString *)className{
    [ZXMethodLog addClassTrace:className];
}
+(void)addClassesTrace:(NSArray <NSString *>*)classNames{
    [ZXMethodLog addClassesTrace:classNames];
}
+(void)addClassTrace:(NSString *)className methodList:(NSArray <NSString *>*)methodList{
    [ZXMethodLog addClassTrace:className methodList:methodList];
}
+(void)addClassTrace:(NSString *)className jsonClassList:(NSArray *)jsonClassList{
    [ZXMethodLog addClassTrace:className jsonClassList:jsonClassList];
}
+(void)addClassTrace:(NSString *)className methodList:(NSArray *)methodList jsonClassList:(NSArray *)jsonClassList{
    [ZXMethodLog addClassTrace:className methodList:methodList jsonClassList:jsonClassList];
}
#pragma mark - 全局请求拦截/修改
+(void)handleRequest:(requestBlock)block{
    [ZXRequestBlock handleRequest:block];
}
#pragma mark - 全局请求与响应拦截/修改
+(void)handleRequest:(requestBlock)requestBlock responseBlock:(responseBlock)responseBlock{
    [ZXRequestBlock handleRequest:requestBlock responseBlock:responseBlock];
}
#pragma mark - 添加轮询
+(ZXPoll *)addTimerWithSec:(long)sec callBack:(pollPerStepBlock)pollPerStepBlock{
    ZXPoll *poll = [[ZXPoll alloc]init];
    [poll addTimerWithSec:sec callBack:pollPerStepBlock];
    return poll;
}
#pragma mark - 网络请求相关
#pragma mark post请求 传入interface
+(void)postInterface:(NSString *)interface postData:(id)postData callBack:(kGetDataEventHandler)_result{
    [ZXHttpRequest postInterface:interface postData:postData callBack:_result];
}
#pragma mark post请求 传入全路径
+(void)postUrl:(NSString *)urlStr postData:(id)postData callBack:(kGetDataEventHandler)_result{
    [ZXHttpRequest postUrl:urlStr postData:postData callBack:_result];
}
#pragma mark get请求 传入interface
+(void)getInterface:(NSString *)interface callBack:(kGetDataEventHandler)_result{
    [ZXHttpRequest getInterface:interface callBack:_result];
}
#pragma mark get请求 传入全路径
+(void)getUrl:(NSString *)urlStr callBack:(kGetDataEventHandler)_result{
    [ZXHttpRequest getUrl:urlStr callBack:_result];
}
#pragma mark - 加密相关
#pragma mark aes加密
+(NSString *)aesEncrypt:(NSString *)data key:(NSString *)key{
    return [ZXEncryption aesEncrypt:data key:key];
}
#pragma mark aes解密
+(NSString *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key{
    return [ZXEncryption aesDecryptWithBase64:data key:key];
}
#pragma mark md5加密
+(NSString *)md5:(NSString *)hashString{
    return [ZXEncryption md5:hashString];
}
#pragma mark - UIKit
#pragma mark - Toast
+(void)showToast:(id)obj{
    [[UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject makeToast:[NSString stringWithFormat:@"%@",obj] duration:1.5 position:CSToastPositionCenter];
}
#pragma mark - UIGet
#pragma mark 获取对应类型UI recursive：是否递归 type：查找的UIType类型
+(NSMutableArray *)getUIInView:(UIView *)view type:(UIType)type recursive:(BOOL)recursive{
    return [[ZXHookUIGet sharedInstance] getUIInView:view type:type recursive:recursive];
}
#pragma mark 获取对应类型UI recursive：是否递归 cls：查找的类名
+(NSMutableArray *)getUIInView:(UIView *)view class:(Class)cls recursive:(BOOL)recursive{
    return [[ZXHookUIGet sharedInstance] getUIInView:view class:cls recursive:recursive];
}
#pragma mark 根据placeHolder从父控件中获取UITextField
+(UITextField *)getTfInView:(UIView *)view placeHolder:(NSString *)placeHolder{
    return [[ZXHookUIGet sharedInstance] getTfInView:view placeHolder:placeHolder];
}
#pragma mark 根据颜色获取控件
+(NSMutableArray *)getUIInView:(UIView *)view color:(UIColor *)color type:(UIType)type{
    return [[ZXHookUIGet sharedInstance] getUIInView:view color:color type:type];
}
#pragma mark 根据frame获取控件
+(NSMutableArray *)getUIInView:(UIView *)view frame:(CGRect)frame type:(UIType)type{
    return [[ZXHookUIGet sharedInstance] getUIInView:view frame:frame type:type];
}
#pragma mark 根据高度获取控件
+(NSMutableArray *)getUIInView:(UIView *)view height:(CGFloat)height type:(UIType)type{
    return [[ZXHookUIGet sharedInstance] getUIInView:view height:height type:type];
}
#pragma mark 根据显示文字内容获取控件
+(NSMutableArray *)getUIInView:(UIView *)view text:(NSString *)text type:(UIType)type{
    return [[ZXHookUIGet sharedInstance] getUIInView:view text:text type:type];
}
#pragma mark 获取keyWindow
+(UIWindow *)getKeyWindow{
    return [ZXHookUIGet getKeyWindow];
}
#pragma mark 获取根控制器
+(UIViewController *)getRootVC{
    return [ZXHookUIGet getRootVC];
}
#pragma mark 获取最前面的控制器
+(UIViewController *)getTopVC{
    return [ZXHookUIGet getTopVC];
}
#pragma mark - 按钮相关
#pragma mark 添加一个全局按钮
+(void)addBtnCallBack:(ZXActionBlock)callBack{
    [self addBtnWithText:@"" CallBack:callBack];
}
+(void)addBtnWithText:(NSString *)text CallBack:(ZXActionBlock)callBack{
    [self addBtnWithText:text frame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 10, 100, 50, 50) CallBack:callBack];
}
+(void)addBtnWithText:(NSString *)text frame:(CGRect)frame CallBack:(ZXActionBlock)callBack{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 10, 100, 50, 50);
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 25;
    btn.backgroundColor = [UIColor redColor];
    __weak typeof(btn) weakBtn = btn;
    [btn addClickAction:^(UIButton *button) {
        callBack(weakBtn);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject addSubview:btn];
    });
}
#pragma mark 获取按钮的所有点击事件方法
+(NSMutableDictionary *)getAllTouchUpAction:(UIButton *)btn{
    return [btn getAllTouchUpAction];
}
#pragma mark 直接调用按钮的所有点击事件方法
+(void)callBtnActions:(UIButton *)btn{
    [btn callBtnActions];
    [ZXHookUtil addClassTrace:@"类名"];
}
#pragma mark - WebView相关
#pragma mark 获取UIWebView的html
+(NSString *)getHtmlWithUIWebView:(UIWebView *)webView{
    return [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
}
#pragma mark 打印WKWebView的html
+(void)logHtmlWithWkWebView:(WKWebView *)webView{
    [webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
        NSLog(@"WKWebViewHtml:%@",htmlStr);
    }];
}
#pragma mark - 系统弹窗相关
#pragma mark 展示一个系统弹窗 传入弹窗的msg
+(void)showAlert:(NSString *)text{
    UIViewController *topVC = [self getTopVC];
    [topVC showAlert:text];
}
#pragma mark 展示一个系统弹窗 传入弹窗的title和msg
+(void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg{
    UIViewController *topVC = [self getTopVC];
    [topVC showAlertWithTitle:title msg:msg];
}
#pragma mark 获取当前显示的系统弹窗
+(UIView *)getCurrentSysAlertV{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject;
    NSArray * arrayViews = keyWindow.subviews;
    for (UIView *subV in arrayViews) {
        if([subV isKindOfClass:[NSClassFromString(@"UITransitionView") class]]){
            for (UIView *sSubV in subV.subviews) {
                if([sSubV isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]){
                    return sSubV;
                }
            }
        }
    }
    return nil;
}
#pragma mark 销毁当前显示的系统弹窗
+(void)disMissCurrentSysAlert{
    UIView *alertV = [self getCurrentSysAlertV];
    if(alertV){
        [((UIViewController *)alertV.nextResponder) dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - 图片选择、展示相关
#pragma mark 从相册或相机中选取图片
-(void)getPhoto:(ImagePickerBlock)photoBlock{
    self.picker = [[ZXImagePicker alloc]init];
    [self.picker getPhotoBlock:photoBlock];
}
#pragma mark 快速展示一张图片
+(void)showImg:(UIImage *)img{
    ZXShowImgView *showImgV = [[ZXShowImgView alloc]init];
    [showImgV showWithImg:img];
}
#pragma mark - Private
-(NSMutableDictionary *)allProNameList{
    if(!_allProNameList){
        _allProNameList = [NSMutableDictionary dictionary];
    }
    return _allProNameList;
}
-(NSMutableDictionary *)proNameList{
    if(!_proNameList){
        _proNameList = [NSMutableDictionary dictionary];
    }
    return _proNameList;
}
@end
