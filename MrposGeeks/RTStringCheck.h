//
//  RTStringCheck.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTStringCheck : NSObject

-(NSString*)getTrimString:(NSString*)trimString;
-(BOOL)checkIsNotNull:(NSString*)chkString;
-(BOOL)checkAlpha:(NSString*)chkString;
-(BOOL)checkNumber:(NSString*)chkString;
-(BOOL)checkNumberNegative:(NSString*)chkString;
-(BOOL)checkAlphaNumber:(NSString*)chkString;
-(BOOL)checkEmail:(NSString*)chkString;
-(BOOL)checkRegString:(NSString*)chkString regString:(NSString*)regString;
-(NSString *)numberToString:(NSInteger)number;
-(NSString *)getNowDateString;
@end
