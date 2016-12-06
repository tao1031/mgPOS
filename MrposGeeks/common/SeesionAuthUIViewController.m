//
//  SeesionAuthUIViewController.m
//  testProtoType
//
//  Created by Admin on 2016/9/1.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "SeesionAuthUIViewController.h"

@implementation SeesionAuthUIViewController
@synthesize busyViewController,messageLabel, activityView;

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    busyViewController = nil;
    messageLabel = nil;
    activityView = nil;
}

-(void) showBusyView {
    [self showBusyViewWithText:@""];
}

-(void) showBusyViewWithText:(NSString*)message {
    if( nil == busyViewController ) {
        busyViewController = [[UIViewController alloc] init];
        busyViewController.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0 alpha:0.3f];
        busyViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        busyViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    if( nil == activityView) {
        //  busy indicator
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        if(self.navigationController.navigationBarHidden == NO) {
            CGRect pos = CGRectMake( (self.view.frame.size.width -activityView.frame.size.width)/2,
                                    (self.view.frame.size.height -activityView.frame.size.height)/2,
                                    activityView.frame.size.width, activityView.frame.size.height);
            activityView.frame = pos;
        }
        else{
            activityView.center=busyViewController.view.center;
        }
        
        [activityView startAnimating];
        [busyViewController.view addSubview:activityView];
    }
    
    if( nil == messageLabel) {
        messageLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(0, activityView.frame.origin.y+activityView.frame.size.height + 10, self.view.frame.size.width, 30.0)];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor whiteColor];
        [busyViewController.view addSubview:messageLabel];
    }
    
    messageLabel.text = message;
    if(nil != self.presentedViewController){
        NSLog(@"present vc not nil : %@", NSStringFromClass([self.presentedViewController class]));
        if( self.presentedViewController == busyViewController ) {
            NSLog(@"busy View presenting.");
        }
    }
    else {
        [self presentViewController:busyViewController animated:NO completion:nil];
    }
}

-(void) hideBusyView {
    if(busyViewController && self.presentedViewController == busyViewController ) {
        [busyViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void) mgAPIRequest:(NSURL*)url postDataDic:(NSDictionary*)postData busyString:(NSString*)busyStr CompletionBlock:completionHandler{
    
    [self showBusyViewWithText:busyStr];
    NSString* postStr = @"";
    if(nil != postData) {
        for(int i=0; i<postData.allKeys.count; i++) {
            if( 0 == i ) {
                postStr = [postStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@", postData.allKeys[i], [postData objectForKey:postData.allKeys[i]]]];
            }
            else {
                postStr = [postStr stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", postData.allKeys[i], [postData objectForKey:postData.allKeys[i]]]];
            }
        }
    }
    
    NSData *pData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%tu",[pData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:pData];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 10.0;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self hideBusyView];
        CompletionBlock _block;
        _block = [completionHandler copy];
        if(_block) {
            _block(data, response, error);
        }
    }];
    [dataTask resume];
}
@end
