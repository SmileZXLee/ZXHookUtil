//
//  UIViewController+TableView.h
//  ZXBaseTableView
//
//  Created by 李兆祥 on 2018/8/20.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBaseTableView.h"
@interface UIViewController (TableView)
///创建ZXBaseTableView 默认styleUITableViewStylePlain
-(ZXBaseTableView *)creatTableView;
///创建ZXBaseTableView并设置style
-(ZXBaseTableView *)creatTableViewWithStyle:(UITableViewStyle)style;
///创建ZXBaseTableView并设置style和frame
-(ZXBaseTableView *)creatTableViewWithStyle:(UITableViewStyle)style frame:(CGRect)frame;
@end
