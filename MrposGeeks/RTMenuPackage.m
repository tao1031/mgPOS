//
//  RTMenuPackage.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackage.h"
#import <REFrostedViewController.h>
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuPackageMain.h"

@interface RTMenuPackage ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}

@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UITextField *textMainTitle;
@property (weak, nonatomic) IBOutlet UITextField *textMainPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation RTMenuPackage

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
    
    [RTViewLayer viewCornerBorderWidth:self.textMainTitle setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textMainTitle setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
    [RTViewLayer viewCornerBorderWidth:self.textMainPrice setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textMainPrice setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
    [RTViewLayer viewCornerRadius:self.btnSave];
    
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.6f]];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    // 讀取套餐資料
    sqlstr = @"select * from `package_main` order by `sort`, `sid` desc";
    NSArray *mainArray = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *itemData in mainArray) {
        [self addPackageMain:[[itemData objectForKey:@"sid"] integerValue]];
    }
}

- (IBAction)actAddPackageMain:(id)sender {
    NSString *sqlstr = @"";
    NSString *textMainTitle = self.textMainTitle.text;
    NSString *textMainPrice = self.textMainPrice.text;
    
    if ([rtStringCheck checkIsNotNull:textMainTitle] && [rtStringCheck checkNumber:textMainPrice]) {
        sqlstr = [NSString stringWithFormat:@"insert into `package_main`(`status`,`name`,`price`,`sort`) values(1,'%@',%@,1)",textMainTitle,textMainPrice];
        [rtDatabase sqlSubForAutoID:sqlstr];
        [self removeAllTableView];
        [self defDataLoad];
        self.textMainTitle.text = @"";
        self.textMainPrice.text = @"";
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

- (void)addPackageMain:(NSInteger) packageID{
    RTMenuPackageMain *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuPackageMain"];
    mainview.packageID = packageID;
    mainview.isOdd = (self.stackView.arrangedSubviews.count % 2 == 1) ? YES : NO;
    [mainview.view.widthAnchor constraintEqualToConstant:250].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

-(void)closeKeybord
{
    [self.textMainTitle resignFirstResponder];
    [self.textMainPrice resignFirstResponder];
}

- (IBAction)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
@end
