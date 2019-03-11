//
//  LoginFooterView.m
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "LoginFooterView.h"
@interface LoginFooterView()

@end
@implementation LoginFooterView

- (IBAction)loginAction:(id)sender {
    if(self.loginBlock){
        self.loginBlock();
    }
}


@end
