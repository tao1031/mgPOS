//
//  RTMenuPackageMainForm.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageMainForm.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"

@interface RTMenuPackageMainForm ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textPrice;
@end

@implementation RTMenuPackageMainForm

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
    
    [RTViewLayer viewCornerBorderWidth:self.textName setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textName setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    [RTViewLayer viewCornerBorderWidth:self.textPrice setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textPrice setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    sqlstr = [NSString stringWithFormat:@"select * from `package_main` where `sid`=%zd",self.packageID];
    NSDictionary *loadDesktopArea = [rtDatabase selectSubForFirst:sqlstr];
    
    if ([rtStringCheck checkNumber:[loadDesktopArea objectForKey:@"sid"]]) {
        self.switchStatus.on = ([[loadDesktopArea objectForKey:@"status"] isEqualToString:@"1"]) ? YES : NO;
        self.textName.text = [loadDesktopArea objectForKey:@"name"];
        self.textPrice.text = [loadDesktopArea objectForKey:@"price"];
    }else{
        [RTAlertView
         showAlert:NSLocalizedString(@"", @"")
         message:NSLocalizedString(@"dataIsNull", @"資料不存在")
         button:NSLocalizedString(@"buttonSure", @"確定")
         ];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)actSave:(id)sender {
    [self closeKeybord];
    NSString *strStatus = (self.switchStatus.on) ? @"1" : @"0";
    NSString *strName = [rtDatabase replacSQLString:self.textName.text];
    NSString *strPrice = [rtDatabase replacSQLString:self.textPrice.text];
    if ([rtStringCheck checkIsNotNull:strName] && [rtStringCheck checkNumber:strPrice]) {
        NSString *sqlstr = [NSString stringWithFormat:@"update `package_main` set `status`=%@,`name`='%@',`price`=%@ where `sid`=%zd",strStatus,strName,strPrice,self.packageID];
        [rtDatabase sqlSub:sqlstr];
        [RTAlertView
         showAlert:NSLocalizedString(@"", @"")
         message:NSLocalizedString(@"saveIsSuccess", @"儲存成功")
         button:NSLocalizedString(@"buttonSure", @"確定")
         ];
    }else{
        [RTAlertView
         showAlert:NSLocalizedString(@"", @"")
         message:NSLocalizedString(@"inputIsError", @"請檢查資料是否正確")
         button:NSLocalizedString(@"buttonSure", @"確定")
         ];
    }
}

-(void)closeKeybord
{
    [self.textName resignFirstResponder];
}

@end
