//
//  ZXShadowView.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/11.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXShadowView.h"
#import "UIView+ZXFrame.h"
@implementation ZXShadowView
static id staticV;
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initOpr];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initOpr];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initOpr];
}

-(void)initOpr{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfTap:)]];
}

-(void)selfTap:(UIGestureRecognizer *)gr{
    [self disMiss];
}
-(void)show{
    staticV = self;
    self.alpha = 0.0;
    self.frame = [UIScreen mainScreen].bounds;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:staticV];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)disMiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [staticV removeFromSuperview];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        [UIView animateWithDuration:duration animations:^{
            self.y = -([UIScreen mainScreen].bounds.size.height - keyboardFrame.origin.y) / 2;
            if(self.y > 10){
                self.y -= 40;
            }
        }];
    });
    
}
@end
