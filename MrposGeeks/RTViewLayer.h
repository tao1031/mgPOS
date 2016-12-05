//
//  RTViewLayer.h
//  MrposGeeks
//
//  Created by Tseng To-Cheng on 2016/9/14.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RTViewLayer : NSObject

+(void)viewCornerRadius:(UIView *)setView;
+(void)viewCornerBorderWidth:(UIView *)setView setBorderWidth:(NSInteger)borderWidth;
+(void)viewCornerBorderColor:(UIView *)setView setBorderColor:(UIColor*)borderColor;
+(void)viewShadow:(UIView *)setView  setShadowColor:(UIColor*)shadowColor;
@end
