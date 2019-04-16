//
//  ZXShowImgView.m
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/11.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ZXShowImgView.h"
@interface ZXShowImgView()
@property(nonatomic,weak)UIImageView *imgV;
@end
@implementation ZXShowImgView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.userInteractionEnabled = YES;
        imgV.backgroundColor = [UIColor clearColor];
        [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVTap)]];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgV];
        self.imgV = imgV;
    }
    return self;
}
-(void)imgVTap{
    [self disMiss];
    
}
-(void)showWithImg:(UIImage *)img{
    [self show];
    self.imgV.frame = self.frame;
    self.imgV.image = img;
}
@end
