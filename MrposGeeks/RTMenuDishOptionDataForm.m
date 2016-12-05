//
//  RTMenuDishOptionDataForm.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDishOptionDataForm.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"

@interface RTMenuDishOptionDataForm ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end

@implementation RTMenuDishOptionDataForm

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
    //初始化編輯表單內容
    self.btnDelete.enabled = NO;
    if ([self.formType isEqualToString:@"edit"]) {
        NSString *sqlstr = @"";
        sqlstr = [NSString stringWithFormat:@"select * from `dish_option_data` where `sid`=%zd and `dish_option_type_sid`=%zd",self.optionDataID,self.optionTypeID];
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
        self.btnDelete.enabled = YES;
    }
    
}

- (IBAction)actSave:(id)sender {
    [self closeKeybord];
    NSString *strStatus = (self.switchStatus.on) ? @"1" : @"0";
    NSString *strName = [rtDatabase replacSQLString:self.textName.text];
    NSString *strPrice = [rtDatabase replacSQLString:self.textPrice.text];
    
    if ([rtStringCheck checkIsNotNull:strName] && ([rtStringCheck checkNumber:strPrice] || [rtStringCheck checkNumberNegative:strPrice])) {
        NSString *sqlstr = @"";
        if ([self.formType isEqualToString:@"edit"]) {
            sqlstr = [NSString stringWithFormat:@"update `dish_option_data` set `status`=%@,`name`='%@',`price`=%@ where `sid`=%zd and `dish_option_type_sid`=%zd",
                      strStatus,
                      strName,
                      strPrice,
                      self.optionDataID,
                      self.optionTypeID];
        }else{
            sqlstr = [NSString stringWithFormat:@"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(%zd, %@, '%@', %@, 1)",
                      self.optionTypeID,
                      strStatus,
                      strName,
                      strPrice];
        }
        
        [rtDatabase sqlSub:sqlstr];
        [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)actDelete:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@""
                                message:NSLocalizedString(@"deleteForSure", @"確定刪除嗎?")
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"buttonSure", @"確定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *sqlstr = [NSString stringWithFormat:@"delete from `dish_option_data` where `sid`=%zd and `dish_option_type_sid`=%zd",
                            self.optionDataID,
                            self.optionTypeID];
        [rtDatabase sqlSub:sqlstr];
        [self.navigationController popViewControllerAnimated:YES];
        [RTAlertView
         showAlert:NSLocalizedString(@"", @"")
         message:NSLocalizedString(@"deleteIsSuccess", @"刪除成功")
         button:NSLocalizedString(@"buttonSure", @"確定")
         ];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"buttonCancle", @"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    UIViewController *selfViewControll = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [selfViewControll presentViewController:alert animated:YES completion:nil];
}

-(void)closeKeybord
{
    [self.textName resignFirstResponder];
    [self.textPrice resignFirstResponder];
}

@end
