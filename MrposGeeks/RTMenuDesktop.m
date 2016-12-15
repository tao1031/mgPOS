//
//  RTMenuDesktop.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDesktop.h"
#import <REFrostedViewController.h>
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTViewLayer.h"
#import "RTAlertView.h"
#import "RTMenuDesktopArea.h"


@interface RTMenuDesktop ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UITextField *textAreaTitle;
@property (weak, nonatomic) IBOutlet UITextField *textAreaLowPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

#ifdef REMOTE_DATA
-(void) remoteDataLoad;
-(void)addDesktopAreaByAreaData:(areaData*) data;
#endif
@end

@implementation RTMenuDesktop

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
#ifdef REMOTE_DATA
    [self remoteDataLoad];
#else
    [self defDataLoad];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)defInit{
    rtDatabase = [[RTDatabaseCore alloc] init];
    rtStringCheck = [[RTStringCheck alloc] init];
    
    [RTViewLayer viewCornerBorderWidth:self.textAreaTitle setBorderWidth:1];
    [RTViewLayer viewCornerBorderWidth:self.textAreaLowPrice setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textAreaTitle setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    [RTViewLayer viewCornerBorderColor:self.textAreaLowPrice setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    [RTViewLayer viewCornerRadius:self.btnSave];
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.6f]];
}

#ifdef REMOTE_DATA
-(void) remoteDataLoad {
    boardDataMgr* bdMgr = [boardDataMgr instance];
    NSArray *desktopAreaArray = bdMgr.areaAry;
    
    for (areaData *areaData in desktopAreaArray) {
        [self addDesktopAreaByAreaData:areaData];
    }
}

-(void)addDesktopAreaByAreaData:(areaData*) data {
    RTMenuDesktopArea *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDesktopArea"];
    mainview.aData = data;
    mainview.isOdd = (self.stackView.arrangedSubviews.count % 2 == 1) ? YES : NO;
    [mainview.view.widthAnchor constraintEqualToConstant:250].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}
#endif

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    // 讀取區域桌次
    sqlstr = @"select * from `desktop_area` order by `sort`, `sid` desc";
    NSArray *desktopAreaArray = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *itemData in desktopAreaArray) {
        [self addDesktopArea:[[itemData objectForKey:@"sid"] integerValue]];
    }
}

- (IBAction)actAddArea:(id)sender {
    NSString *sqlstr = @"";
    NSString *areaTitle = self.textAreaTitle.text;
    NSString *areaLowPrice = self.textAreaLowPrice.text;
    
    if ([rtStringCheck checkIsNotNull:areaTitle] && [rtStringCheck checkNumber:areaLowPrice]) {
        sqlstr = [NSString stringWithFormat:@"insert into `desktop_area`(`status`,`name`,`lowprice`,`sort`) values(1,'%@','%@',1)",areaTitle,areaLowPrice];
        [rtDatabase sqlSubForAutoID:sqlstr];
        [self removeAllTableView];
        [self defDataLoad];
        self.textAreaTitle.text = @"";
        self.textAreaLowPrice.text = @"";
        [self closeKeybord];
    }else{
        [RTAlertView
         showAlert:NSLocalizedString(@"", @"")
         message:NSLocalizedString(@"inputIsError", @"請檢查資料是否正確")
         button:NSLocalizedString(@"buttonSure", @"確定")
         ];
    }
}

-(void)removeAllTableView{
    for (UIView *item in self.stackView.subviews) {
        [self.stackView removeArrangedSubview:item];
    }
    for (UIViewController *itemView in self.childViewControllers) {
        [itemView removeFromParentViewController];
    }
}

- (void)addDesktopArea:(NSInteger) desktopAreaID{
    RTMenuDesktopArea *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDesktopArea"];
    mainview.desktopAreaID = desktopAreaID;
    mainview.isOdd = (self.stackView.arrangedSubviews.count % 2 == 1) ? YES : NO;
    [mainview.view.widthAnchor constraintEqualToConstant:250].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

-(void)closeKeybord
{
    [self.textAreaTitle resignFirstResponder];
    [self.textAreaLowPrice resignFirstResponder];
}

- (IBAction)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
@end
