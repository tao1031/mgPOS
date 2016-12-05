//
//  RTViewLayer.m
//  MrposGeeks
//
//  Created by Tseng To-Cheng on 2016/9/14.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTViewLayer.h"


@implementation RTViewLayer

//圓角
+(void)viewCornerRadius:(UIView *)setView
{
    setView.layer.cornerRadius = 10;
}

//邊框粗細
+(void)viewCornerBorderWidth:(UIView *)setView setBorderWidth:(NSInteger)borderWidth
{
    setView.layer.borderWidth = borderWidth;
}

//邊框顏色
+(void)viewCornerBorderColor:(UIView *)setView setBorderColor:(UIColor*)borderColor
{
    setView.layer.borderColor = borderColor.CGColor;
}

//陰影
+(void)viewShadow:(UIView *)setView  setShadowColor:(UIColor*)shadowColor
{
    setView.layer.masksToBounds = NO;
    setView.layer.shadowColor = shadowColor.CGColor;
    setView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    setView.layer.shadowOpacity = 0.4f;
}


@end
