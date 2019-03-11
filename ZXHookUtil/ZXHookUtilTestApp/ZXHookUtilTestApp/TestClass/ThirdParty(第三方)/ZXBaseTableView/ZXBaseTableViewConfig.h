//
//  ZXBaseTableViewConfig.h
//  ZXBaseTableView
//
//  Created by 李兆祥 on 2018/8/21.
//  Copyright © 2018年 李兆祥. All rights reserved.
//  Github地址：https://github.com/SmileZXLee/ZXBaseTableView

#ifndef ZXBaseTableViewConfig_h
#define ZXBaseTableViewConfig_h
#define IS_IPHONE_X ({\
int cFlag = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top == 44) {\
cFlag = 1;\
}else{\
cFlag = 0;\
}\
}else{\
cFlag = 0;\
}\
cFlag;\
})
#define SYS_STATUSBAR_HEIGHT (IS_IPHONE_X ? 44 : 20)
#define APP_STATUSBAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define kNavi_Height (44 + SYS_STATUSBAR_HEIGHT)
#define REAL_HEIGHT (IS_IPHONE_X ? 10 : 20)
#define KSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREENHEIGHT ([UIScreen mainScreen].bounds.size.height - APP_STATUSBAR_HEIGHT + REAL_HEIGHT)
///model默认去匹配的cell高度属性名 若不存在则动态生成cellHRunTime的属性名
static NSString *const CELLH = @"cellH";
///cell会自动赋值包含“model”的属性
static NSString *const DATAMODEL = @"model";
///model的index属性，存储当前model所属的indexPath
static NSString *const INDEX = @"index";
///若ZXBaseTableView无法自动获取cell高度（zxdata有值即可），且用户未自定义高度，则使用默认高度
static CGFloat const CELLDEFAULTH = 44;
///分页数量
static NSUInteger const PAGECOUNT = 10;

///暂无更多View宽度
static CGFloat const NOMOREDATAVIEWW = 150.0;
///暂无更多View高度
static CGFloat const NOMOREDATAVIEWH = 150.0;
///重新加载按钮宽度
static CGFloat const RELOADBTNW = 80.0;
///重新加载按钮高度
static CGFloat const RELOADBTNH = 25.0;
///重新加载按钮文字
static NSString *const RELOADBTNTEXT = @"重新加载";
///重新加载按钮主题色
static int const RELOADBTNMAINCOLOR = 0xe8412e;
///重新加载按钮上下间距
static int const RELOADBTNMARGIN = 10.0;
///重新加载按钮字体大小
static CGFloat const RELOADBTNFONTSIZE = 13.0;

///暂无更多数据图片
static NSString *const NOMOREDATAIMGNAME = @"nomoreDataImg";
///网络错误普遍处理图片
static NSString *const NETERRIMGNAME = @"netErrImg";

///网络错误特定处理图片与提示内容
///无网络连接
static NSString *const NETERRIMGNAME_NO_NET = @"noNetErrImg";
static NSString *const NETERRTOAST_NO_NET = @"无网络连接";
///请求失败
static NSString *const NETERRIMGNAME_REQ_ERROR = @"noNetErrImg";
static NSString *const NETERRTOAST_REQ_ERROR = @"请求失败";
///请求超时
static NSString *const NETERRIMGNAME_TIME_OUT = @"noNetErrImg";
static NSString *const NETERRTOAST_TIME_OUT = @"请求超时";
///请求地址出错
static NSString *const NETERRIMGNAME_ADDRESS_ERR = @"noNetErrImg";
static NSString *const NETERRTOAST_ADDRESS_ERR = @"请求地址出错";
///其他错误
static NSString *const NETERRIMGNAME_OTHER_ERR = @"";
static NSString *const NETERRTOAST_OTHER_ERR = @"未知错误";

///获取错误code的key
static NSString *const NETERR_CODE = @"code";
///获取错误message的key
static NSString *const NETERR_MESSAGE = @"message";
#endif /* ZXBaseTableViewConfig_h */
