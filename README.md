# ZXHookUtil
### 项目中引用或参照的第三方库:[MonkeyDev](https://github.com/AloneMonkey/MonkeyDev)、[CocoaSecurity](https://github.com/kelp404/CocoaSecurity)、[Base64](https://github.com/nicklockwood/Base64)、[mjcript](https://github.com/CoderMJLee/mjcript)、[ImagePicker](https://www.jianshu.com/p/d87ffcbbb53b)
## Demo
### 使用方法追踪分析sign校验规则，下图为hook测试App的截图，ZXHookUtilTestApp项目即为测试App。
![Image text](http://www.zxlee.cn/methodTrace.png) 
Demo大致分析流程：获取登录控制器，获取登录按钮，打印按钮绑定事件定位登录函数，使用hopper分析登录函数汇编即可快速定位登录操作中使用到的网络请求类、加密类，为这些类添加方法追踪，打印结果：'['所连接的即为一组方法的call和return，方法中嵌套包含的即为此方法中调用的其他方法，添加追踪目标类即可自动追踪其内部方法调用与调用层级并打印，加密协议已一目了然。
***
## 其他主要工具方法
```objective-c
#pragma mark - Foundation
#pragma mark - BaseInfo

/**
 获取BundleId
 */
+(NSString *)getBundleId;

/**
 获取UUID
 */
+(NSString *)getUUID;

/**
 获取App安装路径
 */
+(NSString *)getAppPath;

/**
 获取App沙盒doc路径
 */
+(NSString *)getDocPath;

/**
 获取App沙盒Cache路径
 */
+(NSString *)getCachesPath;

#pragma mark - Class相关
/**
 获取类的所有属性和方法
 @param obj 类名或对象
 @return ZXHookClass获取结果
 */
+(ZXHookClass *)getClassContent:(id)obj;

/**
 获取类的所有方法描述
 @param obj 类名或对象
 @return 类的所有方法描述数组
 */
+(NSArray *)getClassMethodsDescription:(id)obj;


/**
 打印类的所有方法描述
 @param obj 类名或对象
 */
+(void)logClassMethodsDescription:(id)obj;

/**
 获取类的所有属性描述
 @param obj 类名或对象
 @return 类的所有属性描述数组
 */
+(NSArray *)getClassPropertiesDescription:(id)obj;

/**
 打印类的所有属性描述
 @param obj 类名或对象
 */
+(void)logClassPropertiesDescription:(id)obj;

/**
 判断是否是系统类
 @param cls 类
 @return 是否是系统类
 */
+(BOOL)isFoundationClass:(Class)cls;

/**
 获取所有子类
 @param obj 类名或对象
 @return 所有子类数组
 */
+(NSArray *)getSubClass:(id)obj;

/**
 获取所有父类
 @param obj 类名或对象
 @return 所有父类数组
 */
+(NSArray *)getSuperClass:(id)obj;

#pragma mark - 数据转换
/**
 任意类型转字典
 @param obj 待转换的对象
 @return 字典或字典数组
 */
+(id)toDic:(id)obj;

/**
 任意类型转Json字符串
 @param obj 待转换的对象
 @return Json字符串
 */
+(NSString *)toJson:(id)obj;

/**
 任意类型转keyvalue（form-data）类型
 @param obj 待转换的对象
 @return keyvalue（form-data）类型字符串
 */
+(NSString *)tokvStr:(id)obj;

/**
 任意类型转模型 cls为需要转的模型的类，orgObj为需要转的原始数据
 @param cls 需要转的模型的类
 @param orgObj 需要转的原始数据
 @return 模型或模型数组
 */
+(id)toModel:(Class)cls orgObj:(id)orgObj;

#pragma mark - 数据存储
/**
 存储到UserDefaults
 @param obj 需要存储的对象
 @param key 存储key
 */
+(void)saveObj:(id)obj forKey:(NSString *)key;

/**
 从UserDefaults中读取数据
 @param key 存储key
 @return 读取结果
 */
+(id)readObjForKey:(NSString *)key;

/**
 存储到沙盒doc文件夹
 @param obj 需要存储的对象
 @param pathComponent 存储路径
 */
+(void)arcObj:(id)obj pathComponent:pathComponent;

/**
 从沙盒doc文件夹中读取数据
 @param pathComponent 存储路径
 @return 读取结果
 */
+(id)unArcObjPathComponent:(NSString *)pathComponent;

/**
 清除所有缓存数据
 */
+(void)cleanAllData;

/**
 清除UserDefaults数据
 */
+(void)clearUserDefaults;

/**
 清除KeyChain数据
 */
+(void)clearKeyChain;

/**
 根据文件路径清除文件
 @param path 需要清除的文件的全路径
 */
+(void)cleanFileWithPath:(NSString *)path;

#pragma mark - 添加方法跟踪

/**
 添加方法跟踪
 @param className 需要追踪的类名
 */
+(void)addClassTrace:(NSString *)className;

/**
 添加方法跟踪
 @param classNames 需要追踪的类名数组
 */
+(void)addClassesTrace:(NSArray <NSString *>*)classNames;

/**
 添加方法跟踪
 @param className 需要追踪的类名
 @param methodList 需要追踪的对应类中的具体方法，传nin即为类中所有方法
 */
+(void)addClassTrace:(NSString *)className methodList:(NSArray <NSString *>*)methodList;

/**
 添加方法跟踪
 @param className 需要追踪的类名
 @param jsonClassList 方法打印中需要转为json的方法名数组
 */
+(void)addClassTrace:(NSString *)className jsonClassList:(NSArray *)jsonClassList;

/**
 添加方法跟踪
 @param className 需要追踪的类名
 @param methodList 需要追踪的对应类中的具体方法，传nin即为类中所有方法
 @param jsonClassList 方法打印中需要转为json的方法名数组
 */
+(void)addClassTrace:(NSString *)className methodList:(NSArray *)methodList jsonClassList:(NSArray *)jsonClassList;

#pragma mark - 全局请求拦截/修改
/**
 全局请求拦截/修改
 @param block request拦截回调
 */
+(void)handleRequest:(requestBlock)block;

#pragma mark - 添加轮询
/**
 添加轮询
 @param sec 轮询时间（秒）
 @param pollPerStepBlock 轮询方法回调
 @return ZXPoll对象
 */
+(ZXPoll *)addTimerWithSec:(long)sec callBack:(pollPerStepBlock)pollPerStepBlock;

#pragma mark - 网络请求相关
/**
 post请求
 @param interface 请求子路径
 @param postData 请求体，字典
 @param _result 请求回调block，block中result为是否请求成功，data为字典
 */
+(void)postInterface:(NSString *)interface postData:(id)postData callBack:(kGetDataEventHandler)_result;

/**
 post请求
 @param urlStr 请求全路径
 @param postData 请求体，字典
 @param _result 请求回调block，block中result为是否请求成功，data为字典
 */
+(void)postUrl:(NSString *)urlStr postData:(id)postData callBack:(kGetDataEventHandler)_result;

/**
 get请求
 @param interface 请求子路径
 @param _result 请求回调block，block中result为是否请求成功，data为字典
 */
+(void)getInterface:(NSString *)interface callBack:(kGetDataEventHandler)_result;

/**
 get请求
 @param urlStr 请求全路径
 @param _result 请求回调block，block中result为是否请求成功，data为字典
 */
+(void)getUrl:(NSString *)urlStr callBack:(kGetDataEventHandler)_result;

#pragma mark - 加密/解密相关
/**
 aes解密
 @param data 待解密的base64字符串
 @param key 解密key
 @return 解密结果
 */
+(NSString *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key;

/**
 aes加密
 @param data 待加密的字符串
 @param key 加密key
 @return 加密结果
 */
+(NSString *)aesEncrypt:(NSString *)data key:(NSString *)key;

/**
 md5加密
 @param hashString 待加密的字符串
 @return 加密结果
 */
+(NSString *)md5:(NSString *)hashString;

#pragma mark - UIKit
#pragma mark - Toast
/**
 Toast
 @param obj Toast显示内容
 */
+(void)showToast:(id)obj;

#pragma mark - UIGet
/**
 获取对应类型view
 @param view 控制器view
 @param type 查找的view的UI类型
 @param recursive 是否递归查找
 @return 查找结果
 */
+(NSMutableArray *)getUIInView:(UIView *)view type:(UIType)type recursive:(BOOL)recursive;

/**
 获取对应类型view
 @param view 控制器view
 @param cls 查找的view类名
 @param recursive 是否递归查找
 @return 查找结果
 */
+(NSMutableArray *)getUIInView:(UIView *)view class:(Class)cls recursive:(BOOL)recursive;

/**
 根据placeHolder从控制器获取UITextField
 @param view 控制器view
 @param placeHolder UITextField的placeHolder
 @return 查找结果
 */
+(UITextField *)getTfInView:(UIView *)view placeHolder:(NSString *)placeHolder;

/**
 根据颜色获取控件
 @param view 控制器view
 @param color 查找的view颜色
 @param type 查找的view的UI类型
 @return 查找结果
 */
+(NSMutableArray *)getUIInView:(UIView *)view color:(UIColor *)color type:(UIType)type;

/**
 根据frame获取控件
 @param view 控制器view
 @param frame 查找的view的frame
 @param type 查找的view的UI类型
 @return 查找结果
 */
+(NSMutableArray *)getUIInView:(UIView *)view frame:(CGRect)frame type:(UIType)type;

/**
 根据高度获取控件
 @param view 控制器view
 @param height 查找的view的height
 @param type 查找的view的UI类型
 @return 查找结果
 */
+(NSMutableArray *)getUIInView:(UIView *)view height:(CGFloat)height type:(UIType)type;

/**
 根据显示文字内容获取控件
 @param view 控制器view
 @param text 查找的view显示的text
 @param type 查找的view的UI类型
 @return 查找结果
 */
+(NSMutableArray *)getUIInView:(UIView *)view text:(NSString *)text type:(UIType)type;

/**
 获取keyWindow
 @return keyWindow
 */
+(UIWindow *)getKeyWindow;

/**
 获取根控制器
 @return 根控制器
 */
+(UIViewController *)getRootVC;

/**
 获取最前面的控制器
 @return 最前面的控制器
 */
+(UIViewController *)getTopVC;

#pragma mark - 按钮相关
/**
 添加一个全局按钮
 @param callBack 按钮点击事件回调
 */
+(void)addBtnCallBack:(ZXActionBlock)callBack;

/**
 添加一个全局按钮
 @param text 按钮显示文字
 @param callBack 按钮点击事件回调
 */
+(void)addBtnWithText:(NSString *)text CallBack:(ZXActionBlock)callBack;

/**
 添加一个全局按钮
 @param text 按钮显示文字
 @param frame 按钮frame
 @param callBack 按钮点击事件回调
 */
+(void)addBtnWithText:(NSString *)text frame:(CGRect)frame CallBack:(ZXActionBlock)callBack;

/**
 获取按钮的所有点击事件方法
 @param btn 目标Btn
 @return 目标Btn的所有target和对应绑定的事件方法
 */
+(NSMutableDictionary *)getAllTouchUpAction:(UIButton *)btn;

/**
 直接调用按钮的所有点击事件方法
 @param btn 需要调用点击事件的按钮
 */
+(void)callBtnActions:(UIButton *)btn;

#pragma mark - WebView相关
/**
 获取UIWebView的html
 @param webView UIWebView
 @return UIWebView的html
 */
+(NSString *)getHtmlWithUIWebView:(UIWebView *)webView;

/**
 打印WKWebView的html
 @param webView WkWebView
 */
+(void)logHtmlWithWkWebView:(WKWebView *)webView;

#pragma mark - 系统弹窗相关
/**
 展示一个系统弹窗
 @param text 弹窗的msg
 */
+(void)showAlert:(NSString *)text;

/**
 展示一个系统弹窗
 @param title 弹窗的title
 @param msg 弹窗的msg
 */
+(void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg;

/**
 获取当前显示的系统弹窗
 @return 当前显示的系统弹窗
 */
+(UIView *)getCurrentSysAlertV;

/**
 销毁当前显示的系统弹窗
 */
+(void)disMissCurrentSysAlert;

#pragma mark - 图片选择、展示相关
/**
 从相册或相机中选取图片
 @param photoBlock 选择图片回调
 */
-(void)getPhoto:(ImagePickerBlock)photoBlock;

#pragma mark 快速展示一张图片
/**
 快速展示一张图片
 @param img 需要展示的图片
 */
+(void)showImg:(UIImage *)img;
```
## TODO：添加其他便捷的工具函数，提高逆向分析效率
