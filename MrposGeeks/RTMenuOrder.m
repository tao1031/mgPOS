//
//  RTMenuOrder.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/20.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrder.h"
#import <REFrostedViewController.h>
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuOrderArea.h"
#import "RTMenuOrderOutside.h"

@interface RTMenuOrder ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UIButton *btnInside;
@property (weak, nonatomic) IBOutlet UIButton *btnOutside;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation RTMenuOrder

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
    [self defDataLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)defInit{
    rtDatabase = [[RTDatabaseCore alloc] init];
    rtStringCheck = [[RTStringCheck alloc] init];
    
    [RTViewLayer viewCornerRadius:self.btnInside];
    [RTViewLayer viewCornerRadius:self.btnOutside];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    // 讀取區域桌次
    sqlstr = @"select * from `desktop_area` where `status`=1 order by `sort`, `sid` desc";
    NSArray *desktopAreaArray = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *itemData in desktopAreaArray) {
        [self addDesktopArea:[[itemData objectForKey:@"sid"] integerValue]];
    }
}

- (void)addDesktopArea:(NSInteger) desktopAreaID{
    RTMenuOrderArea *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderArea"];
    mainview.desktopAreaID = desktopAreaID;
    mainview.isOdd = (self.stackView.arrangedSubviews.count % 2 == 1) ? YES : NO;
    [mainview.view.widthAnchor constraintEqualToConstant:250].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

- (IBAction)actToOutside:(id)sender {
    RTMenuOrderOutside *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderOutside"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)showMenu {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
@end
