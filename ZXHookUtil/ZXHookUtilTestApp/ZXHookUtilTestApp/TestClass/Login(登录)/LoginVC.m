//
//  LoginVC.m
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "LoginVC.h"
#import "LoginHeaderView.h"
#import "LoginFooterView.h"
#import "LoginCell.h"
#import "LoginModel.h"
#import "EncryptionTool.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet ZXBaseTableView *tableView;
@property(nonatomic,strong)LoginModel *accountModel;
@property(nonatomic,strong)LoginModel *pwdModel;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.cellClassAtIndexPath = ^Class(NSIndexPath *indexPath) {
        return [LoginCell class];
    };
    self.tableView.headerClassInSection = ^Class(NSInteger section) {
        return [LoginHeaderView class];
    };
    self.tableView.footerClassInSection = ^Class(NSInteger section) {
        return [LoginFooterView class];
    };
    self.tableView.footerViewInSection = ^(NSUInteger section, LoginFooterView *footerView, NSMutableArray *secArr) {
        footerView.loginBlock = ^{
            [self goLogin];
        };
    };
    self.tableView.zxDatas = (NSMutableArray *)[self getLoginModelArr];
}

-(NSArray *)getLoginModelArr{
    LoginModel *accountModel = [[LoginModel alloc]init];
    accountModel.type = 0;
    self.accountModel = accountModel;
    LoginModel *pwdModel = [[LoginModel alloc]init];
    pwdModel.type = 1;
    self.pwdModel = pwdModel;
    return @[accountModel,pwdModel];
}

-(void)goLogin{
    [self.view endEditing:YES];
    if([self noNull]){
        NSString *acc = self.accountModel.value;
        NSString *pwd = [EncryptionTool aesEncrypt:self.pwdModel.value key:@"xsahdjsad890"];
        [HttpRequest postInterface:@"/login" postData:@{@"account":acc,@"pwd":pwd} callBack:^(BOOL result, id  _Nonnull data) {
            if(result){
                ZXToast(@"登录成功");
            }
        }];
    }else{
        ZXToast(@"账号或密码不得为空");
    }
}

-(BOOL)noNull{
    return self.accountModel.value.length && self.pwdModel.value.length;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
