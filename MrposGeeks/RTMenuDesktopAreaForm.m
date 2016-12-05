//
//  RTMenuDesktopAreaForm.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDesktopAreaForm.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"

@interface RTMenuDesktopAreaForm ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textLowPrice;
@end

@implementation RTMenuDesktopAreaForm

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
    [RTViewLayer viewCornerBorderWidth:self.textLowPrice setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textName setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    [RTViewLayer viewCornerBorderColor:self.textLowPrice setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    sqlstr = [NSString stringWithFormat:@"select * from `desktop_area` where `sid`=%zd",self.desktopAreaID];
    NSDictionary *loadDesktopArea = [rtDatabase selectSubForFirst:sqlstr];
    
    if ([rtStringCheck checkNumber:[loadDesktopArea objectForKey:@"sid"]]) {
        self.switchStatus.on = ([[loadDesktopArea objectForKey:@"status"] isEqualToString:@"1"]) ? YES : NO;
        self.textName.text = [loadDesktopArea objectForKey:@"name"];
        self.textLowPrice.text = [loadDesktopArea objectForKey:@"lowprice"];
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
    NSString *strLowPrice = [rtDatabase replacSQLString:self.textLowPrice.text];    
    if ([rtStringCheck checkIsNotNull:strName] && [rtStringCheck checkNumber:strLowPrice]) {
        NSString *sqlstr = [NSString stringWithFormat:@"update `desktop_area` set `status`=%@,`name`='%@',`lowprice`=%@ where `sid`=%zd",strStatus,strName,strLowPrice,self.desktopAreaID];
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
    [self.textLowPrice resignFirstResponder];
}
@end
