//
//  RTMenuDishSettingViewController.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/19.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDish.h"
#import <REFrostedViewController.h>
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuDishType.h"

@interface RTMenuDish ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UITextField *textTypeTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation RTMenuDish

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
    
    [RTViewLayer viewCornerBorderWidth:self.textTypeTitle setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textTypeTitle setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
    
    [RTViewLayer viewCornerRadius:self.btnSave];
    
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.6f]];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    // 讀取餐點類型
    sqlstr = @"select * from `dish_type` order by `sort`, `sid` desc";
    NSArray *typeAreaArray = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *itemData in typeAreaArray) {
        [self addDishOption:[[itemData objectForKey:@"sid"] integerValue]];
    }
}

- (IBAction)actAddDishType:(id)sender {
    NSString *sqlstr = @"";
    NSString *textTypeTitle = self.textTypeTitle.text;
    
    if ([rtStringCheck checkIsNotNull:textTypeTitle]) {
        sqlstr = [NSString stringWithFormat:@"insert into `dish_type`(`status`,`name`,`sort`) values(1,'%@',1)",textTypeTitle];
        [rtDatabase sqlSubForAutoID:sqlstr];
        [self removeAllTableView];
        [self defDataLoad];
        self.textTypeTitle.text = @"";
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

- (void)addDishOption:(NSInteger) desktopAreaID{
    RTMenuDishType *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishType"];
    mainview.dishTypeID = desktopAreaID;
    mainview.isOdd = (self.stackView.arrangedSubviews.count % 2 == 1) ? YES : NO;
    [mainview.view.widthAnchor constraintEqualToConstant:250].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

-(void)closeKeybord
{
    [self.textTypeTitle resignFirstResponder];
}

- (IBAction)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
@end
