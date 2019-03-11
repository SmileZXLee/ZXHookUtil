//
//  LoginCell.m
//  ZXHookUtilTestApp
//
//  Created by 李兆祥 on 2019/3/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "LoginCell.h"
#import "LoginModel.h"
@interface LoginCell()<UITextFieldDelegate>
@property(nonatomic,strong)LoginModel *loginModel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTf;

@end
@implementation LoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.valueTf.delegate = self;
}
-(void)setLoginModel:(LoginModel *)loginModel{
    _loginModel = loginModel;
    if(loginModel.type == 0){
        self.typeLabel.text = @"账号";
    }else{
        self.typeLabel.text = @"密码";
    }
    self.valueTf.placeholder = [NSString stringWithFormat:@"请输入%@",self.typeLabel.text];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.loginModel.value = textField.text;
}

@end
