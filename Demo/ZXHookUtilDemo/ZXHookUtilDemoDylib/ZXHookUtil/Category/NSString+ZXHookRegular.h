//
//  NSString+ZXHookRegular.h
//  
//
//  Created by 李兆祥 on 2019/2/16.
//

#import <Foundation/Foundation.h>

@interface NSString (ZXHookRegular)
-(NSString *)regularWithPattern:(NSString *)pattern;
-(NSArray *)regularsWithPattern:(NSString *)pattern;
-(NSString *)matchStrWithPre:(NSString *)pre sub:(NSString *)sub;
-(NSArray *)matchsStrWithPre:(NSString *)pre sub:(NSString *)sub;
-(NSString *)removeAllElement:(NSString *)element;
-(NSString *)removeAllElements:(NSArray *)elements;
-(NSString *)upperFirstCharacter;
@end
