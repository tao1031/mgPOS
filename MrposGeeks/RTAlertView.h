//
//  RTAlertView.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/2.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTAlertView : NSObject

+ (void)showAlert:(NSString *)title message:(NSString *)message button:(NSString *)buttonTitle;

@end
