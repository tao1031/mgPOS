//
//  RTAlertView.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/2.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTAlertView.h"
#import <UIKit/UIKit.h>

@implementation RTAlertView

+ (void)showAlert:(NSString *)title message:(NSString *)message button:(NSString *)buttonTitle
{
    UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:message
                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:defAction];
    UIViewController *selfViewControll = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [selfViewControll presentViewController:alert animated:YES completion:nil];
}
@end
