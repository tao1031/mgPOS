//
//  RTMenuOption.m
//  MrposGeeks
//
//  Created by Vexon Elite on 2016/9/6.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//


#import "RTMenuDishOption.h"
#import <REFrostedViewController.h>
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuDishOptionType.h"

@interface RTMenuDishOption ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UITextField *textOptionTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation RTMenuDishOption

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
    
    [RTViewLayer viewCornerBorderWidth:self.textOptionTitle setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textOptionTitle setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
    
    [RTViewLayer viewCornerRadius:self.btnSave];
    
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.6f]];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    // 讀取餐點選項類型
    sqlstr = @"select * from `dish_option_type` order by `sort`, `sid` desc";
    NSArray *desktopAreaArray = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *itemData in desktopAreaArray) {
        [self addDishOption:[[itemData objectForKey:@"sid"] integerValue]];
    }
}

- (IBAction)actAddOptionType:(id)sender {
    NSString *sqlstr = @"";
    NSString *textOptionTitle = self.textOptionTitle.text;

    if ([rtStringCheck checkIsNotNull:textOptionTitle]) {
        sqlstr = [NSString stringWithFormat:@"insert into `dish_option_type`(`status`,`name`,`multiplechoose`,`sort`) values(1,'%@',1,1)",textOptionTitle];
        [rtDatabase sqlSubForAutoID:sqlstr];
        [self removeAllTableView];
        [self defDataLoad];
        self.textOptionTitle.text = @"";
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
    RTMenuDishOptionType *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishOptionType"];
    mainview.dishOptionID = desktopAreaID;
    mainview.isOdd = (self.stackView.arrangedSubviews.count % 2 == 1) ? YES : NO;
    [mainview.view.widthAnchor constraintEqualToConstant:250].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

-(void)closeKeybord
{
    [self.textOptionTitle resignFirstResponder];
}

- (IBAction)showMenu {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

@end
