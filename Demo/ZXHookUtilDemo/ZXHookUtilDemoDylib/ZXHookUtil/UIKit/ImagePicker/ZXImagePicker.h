//
//  ZXImagePicker.h
//  ZXHookUtilDemoDylib
//
//  Created by 李兆祥 on 2019/3/11.
//  Copyright © 2019 李兆祥. All rights reserved.
//  From https://www.jianshu.com/p/d87ffcbbb53b

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^ImagePickerBlock)(UIImage *image);
@interface ZXImagePicker : NSObject
- (void)getPhotoBlock:(ImagePickerBlock)photoBlock;
@end
