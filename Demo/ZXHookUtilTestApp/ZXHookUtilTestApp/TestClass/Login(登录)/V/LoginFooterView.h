//
//  LoginFooterView.h
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginFooterView : UIView
@property(nonatomic,copy)void (^loginBlock)(void);
@end

NS_ASSUME_NONNULL_END
