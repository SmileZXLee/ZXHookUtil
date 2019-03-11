//
//  LoginModel.h
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject
///0账号 1密码
@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString *value;
@end

NS_ASSUME_NONNULL_END
