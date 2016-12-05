//
//  RTMenuDishOptionTypeForm.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDishOptionTypeForm.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"

@interface RTMenuDishOptionTypeForm ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UISwitch *switchMutChoose;
@end

@implementation RTMenuDishOptionTypeForm

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
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    sqlstr = [NSString stringWithFormat:@"select * from `dish_option_type` where `sid`=%zd",self.optionTypeID];
    NSDictionary *loadDesktopArea = [rtDatabase selectSubForFirst:sqlstr];
    
    if ([rtStringCheck checkNumber:[loadDesktopArea objectForKey:@"sid"]]) {
        self.switchStatus.on = ([[loadDesktopArea objectForKey:@"status"] isEqualToString:@"1"]) ? YES : NO;
        self.switchMutChoose.on = ([[loadDesktopArea objectForKey:@"multiplechoose"] isEqualToString:@"1"]) ? YES : NO;
        self.textName.text = [loadDesktopArea objectForKey:@"name"];
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
    NSString *strMutChoose = (self.switchMutChoose.on) ? @"1" : @"0";
    NSString *strName = [rtDatabase replacSQLString:self.textName.text];
    if ([rtStringCheck checkIsNotNull:strName]) {
        NSString *sqlstr = [NSString stringWithFormat:@"update `dish_option_type` set `status`=%@,`name`='%@', multiplechoose=%@ where `sid`=%zd",strStatus,strName,strMutChoose,self.optionTypeID];
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
