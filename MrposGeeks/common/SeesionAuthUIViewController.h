//
//  SeesionAuthUIViewController.h
//  testProtoType
//
//  Created by Admin on 2016/9/1.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface SeesionAuthUIViewController : UIViewController<NSURLSessionDelegate>{
    UIViewController *busyViewController;
    UIActivityIndicatorView *activityView;
    UILabel *messageLabel;
}

@property (nonatomic, retain) UIViewController *busyViewController;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UILabel *messageLabel;

-(void) showBusyView;
-(void) showBusyViewWithText:(NSString*)message;
-(void) hideBusyView;
-(void) mgAPIRequest:(NSURL*)url postDataDic:(NSDictionary*)postData busyString:(NSString*)busyStr CompletionBlock:completionHandler;
@end
