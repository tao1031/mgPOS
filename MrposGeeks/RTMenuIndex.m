//
//  RTMenuIndexViewController.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/19.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuIndex.h"
#import <REFrostedViewController.h>

@interface RTMenuIndex ()

@end

@implementation RTMenuIndex

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
@end
