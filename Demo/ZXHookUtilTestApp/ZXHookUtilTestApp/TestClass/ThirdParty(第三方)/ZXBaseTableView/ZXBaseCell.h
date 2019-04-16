//
//  ZXBaseCell.h
//  ZXBaseTableViewDemo
//
//  Created by 李兆祥 on 2018/8/22.
//  Copyright © 2018年 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#warning 可以在自己的cell中声明model（或包含model，大小写不影响）属性 或直接继承此类，无需声明model（或包含model字符串，大小写不影响属性，在.m中重写setmodel方法即可设置cell的数据
@interface ZXBaseCell : UITableViewCell
@property(nonatomic, strong)id model;
@end
