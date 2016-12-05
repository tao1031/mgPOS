//
//  RTStringCheck.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTStringCheck.h"

@implementation RTStringCheck

//去空白
-(NSString*)getTrimString:(NSString*)trimString
{
    return [trimString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//空字串
-(BOOL)checkIsNotNull:(NSString*)chkString
{
    chkString = [self getTrimString:chkString];
    if (chkString.length==0) {
        return NO;
    }
    return YES;
}

//英文
-(BOOL)checkAlpha:(NSString*)chkString
{
    if (chkString.length==0) {
        return NO;
    }
    NSString *regExPattern = @"[a-zA-Z]*";
    return [self checkRegString:chkString regString:regExPattern];
}

//數字
-(BOOL)checkNumber:(NSString*)chkString
{
    if (chkString.length==0) {
        return NO;
    }
    NSString *regExPattern = @"[0-9]*";
    return [self checkRegString:chkString regString:regExPattern];
}

//負數數字
-(BOOL)checkNumberNegative:(NSString*)chkString
{
    if (chkString.length==0) {
        return NO;
    }
    NSString *regExPattern = @"-[0-9]*";
    return [self checkRegString:chkString regString:regExPattern];
}

//英文數字
-(BOOL)checkAlphaNumber:(NSString*)chkString
{
    if (chkString.length==0) {
        return NO;
    }
    NSString *regExPattern = @"[a-zA-Z0-9]*";
    return [self checkRegString:chkString regString:regExPattern];
}

//E-mail
-(BOOL)checkEmail:(NSString*)chkString
{
    if (chkString.length==0) {
        return NO;
    }
    NSString *regExPattern = @"[_a-z0-9-]+(\\.[_a-z0-9-]+)*@([0-9a-z][0-9a-z-]+\\.)+[a-z]{2,3}";
    return [self checkRegString:chkString regString:regExPattern];
}

//自定義
-(BOOL)checkCustomize:(NSString*)chkString regString:(NSString*)regString
{
    if (chkString.length==0) {
        return NO;
    }
    return [self checkRegString:chkString regString:regString];
}

-(BOOL)checkRegString:(NSString*)chkString regString:(NSString*)regString
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regString] evaluateWithObject:chkString];
}

//轉千分位
-(NSString *)numberToString:(NSInteger)number
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:number]];
    return formatted;
}

-(NSString *)getNowDateString{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *nowDate = [NSDate date];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *nowDateString = [dateFormat stringFromDate:nowDate];
    return nowDateString;
}


@end
