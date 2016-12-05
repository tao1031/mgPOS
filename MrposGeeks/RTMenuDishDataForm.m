//
//  RTMenuDishDataForm.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDishDataForm.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTMenuDishDataFormCell.h"
#import "RTViewLayer.h"

@interface RTMenuDishDataForm ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    NSMutableArray *optionItemArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UISwitch *switchInside;
@property (weak, nonatomic) IBOutlet UISwitch *switchOutside;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@end

@implementation RTMenuDishDataForm

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
    optionItemArray = [[NSMutableArray alloc] init];
    
    [RTViewLayer viewCornerBorderWidth:self.textName setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textName setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
    [RTViewLayer viewCornerBorderWidth:self.textPrice setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textPrice setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
    [RTViewLayer viewCornerBorderWidth:self.tableView setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.tableView setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];    
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    //讀取基本餐點選項
    sqlstr = [NSString stringWithFormat:@"select * from `dish_option_type` where `status`=1 order by sort,sid "];
    optionItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    //初始化編輯表單內容
    NSMutableArray *optionStatusArray;
    self.btnDelete.enabled = NO;
    if ([self.formType isEqualToString:@"edit"]) {
        //基本欄位
        sqlstr = [NSString stringWithFormat:@"select * from `dish_data` where `sid`=%zd and `dish_type_sid`=%zd",self.dishDataID,self.dishTypeID];
        NSDictionary *loadDesktopArea = [rtDatabase selectSubForFirst:sqlstr];
        
        if ([rtStringCheck checkNumber:[loadDesktopArea objectForKey:@"sid"]]) {
            self.switchStatus.on = ([[loadDesktopArea objectForKey:@"status"] isEqualToString:@"1"]) ? YES : NO;
            self.switchInside.on = ([[loadDesktopArea objectForKey:@"isinside"] isEqualToString:@"1"]) ? YES : NO;
            self.switchOutside.on = ([[loadDesktopArea objectForKey:@"isoutside"] isEqualToString:@"1"]) ? YES : NO;
            self.textName.text = [loadDesktopArea objectForKey:@"name"];
            self.textPrice.text = [loadDesktopArea objectForKey:@"price"];
            
            //選項設定值
            sqlstr = [NSString stringWithFormat:@"select * from `dish_data_option` where `dish_data_sid`=%zd",self.dishDataID];
            optionStatusArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
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
    
    //解決初始選項設定
    for (NSMutableDictionary *dic in optionItemArray) {
        [dic setObject:@"0" forKey:@"setting"];
        for (NSMutableDictionary *item in optionStatusArray) {
            if ([[item objectForKey:@"dish_option_type_sid"] isEqualToString:[dic objectForKey:@"sid"]]) {
                [dic setObject:@"1" forKey:@"setting"];
                // break;
            }
        }
    }
}

- (IBAction)actSave:(id)sender {
    [self closeKeybord];
    NSString *strStatus = (self.switchStatus.on) ? @"1" : @"0";
    NSString *strInside = (self.switchInside.on) ? @"1" : @"0";
    NSString *strOutside = (self.switchOutside.on) ? @"1" : @"0";
    NSString *strName = [rtDatabase replacSQLString:self.textName.text];
    NSString *strPrice = [rtDatabase replacSQLString:self.textPrice.text];
    
    if ([rtStringCheck checkIsNotNull:strName] && [rtStringCheck checkNumber:strPrice]) {
        NSString *sqlstr;
        
        if ([self.formType isEqualToString:@"edit"]) {
            //儲存主表
            sqlstr = [NSString stringWithFormat:@"update `dish_data` set `status`=%@,`name`='%@',`price`=%@,`isinside`=%@,`isoutside`=%@ where `sid`=%zd and `dish_type_sid`=%zd",
                      strStatus,
                      strName,
                      strPrice,
                      strInside,
                      strOutside,
                      self.dishDataID,
                      self.dishTypeID];
            [rtDatabase sqlSub:sqlstr];
            
            //清空選項
            sqlstr = [NSString stringWithFormat:@"delete from `dish_data_option` where `dish_data_sid`=%zd",self.dishDataID];
            [rtDatabase sqlSub:sqlstr];
            

        }else{
            //儲存主表
            sqlstr = [NSString stringWithFormat:@"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(%zd, %@, '%@', %@, %@, %@, 1)",
                      self.dishTypeID,
                      strStatus,
                      strName,
                      strPrice,
                      strInside,
                      strOutside];
            self.dishDataID = [rtDatabase sqlSubForAutoID:sqlstr];
        }
        
        for (NSDictionary *dic in optionItemArray) {
            if ([[dic objectForKey:@"setting"] isEqualToString:@"1"]) {
                sqlstr = [NSString stringWithFormat:@"insert into `dish_data_option`(`dish_data_sid`,`dish_option_type_sid`) values(%zd, %@)",
                          self.dishDataID,
                          [dic objectForKey:@"sid"]];
                [rtDatabase sqlSub:sqlstr];
            }
        }
        
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
        NSString *sqlstr = @"";
        
        sqlstr = [NSString stringWithFormat:@"delete from `dish_data` where `sid`=%zd and `dish_type_sid`=%zd",
                            self.dishDataID,
                            self.dishTypeID];
        [rtDatabase sqlSub:sqlstr];
        
        sqlstr = [NSString stringWithFormat:@"delete from `dish_data_option` where `dish_data_sid`=%zd",self.dishDataID];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return optionItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuDishDataFormCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuDishDataFormCell" forIndexPath:indexPath];
    cell.itemData = [optionItemArray objectAtIndex:indexPath.row];
    [cell updateView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)closeKeybord
{
    [self.textName resignFirstResponder];
    [self.textPrice resignFirstResponder];
}

@end
