//
//  ViewController.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/18.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "RTLogin.h"

@interface ViewController ()
{
    AppDelegate *mainDelegate;
    NSTimer *changeViewTimer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    changeViewTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(handleTimer:) userInfo: nil repeats: NO];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleTimer: (NSTimer *) timer{
    [self pushPage];
}

-(void)pushPage
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTLogin" bundle:nil];
    RTLogin *mainview = [sb instantiateViewControllerWithIdentifier:@"RTLogin"];
    mainDelegate.window.rootViewController = mainview;
    [UIView transitionWithView:mainDelegate.window
                               duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                               animations:^{ mainDelegate.window.rootViewController = mainview; }
                               completion:nil];    
}

@end
