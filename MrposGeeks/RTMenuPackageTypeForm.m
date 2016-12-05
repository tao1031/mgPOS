//
//  RTMenuPackageTypeForm.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageTypeForm.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuPackageTypeFormCell.h"

@interface RTMenuPackageTypeForm ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    NSMutableArray *dishtypeItemArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textMaxCount;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end

@implementation RTMenuPackageTypeForm

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
    dishtypeItemArray = [[NSMutableArray alloc] init];
    
    [RTViewLayer viewCornerBorderWidth:self.textName setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textName setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
    [RTViewLayer viewCornerBorderWidth:self.textMaxCount setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textMaxCount setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];

    [RTViewLayer viewCornerBorderWidth:self.tableView setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.tableView setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];    
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    //讀取基本餐點選項
    sqlstr = [NSString stringWithFormat:@"select * from `dish_type` where `status`=1 order by sort,sid "];
    dishtypeItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    //初始化編輯表單內容
    NSMutableArray *typeStatusArray;
    self.btnDelete.enabled = NO;
    if ([self.formType isEqualToString:@"edit"]) {
        //基本欄位
        sqlstr = [NSString stringWithFormat:@"select * from `package_type` where `sid`=%zd and `package_main_sid`=%zd",self.typeID,self.packageID];
        NSDictionary *loadDesktopArea = [rtDatabase selectSubForFirst:sqlstr];
        
        if ([rtStringCheck checkNumber:[loadDesktopArea objectForKey:@"sid"]]) {
            self.switchStatus.on = ([[loadDesktopArea objectForKey:@"status"] isEqualToString:@"1"]) ? YES : NO;
            self.textName.text = [loadDesktopArea objectForKey:@"name"];
            self.textMaxCount.text = [loadDesktopArea objectForKey:@"maxcount"];
            
            //選項設定值
            sqlstr = [NSString stringWithFormat:@"select * from `package_type_dishtype` where `package_type_sid`=%zd",self.typeID];
            typeStatusArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
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
    for (NSMutableDictionary *dic in dishtypeItemArray) {
        [dic setObject:@"0" forKey:@"setting"];
        for (NSMutableDictionary *item in typeStatusArray) {
            if ([[item objectForKey:@"dish_type_sid"] isEqualToString:[dic objectForKey:@"sid"]]) {
                [dic setObject:@"1" forKey:@"setting"];
                // break;
            }
        }
    }
}

- (IBAction)actSave:(id)sender {
    [self closeKeybord];
    NSString *strStatus = (self.switchStatus.on) ? @"1" : @"0";
    NSString *strName = [rtDatabase replacSQLString:self.textName.text];
    NSString *strMaxCount = [rtDatabase replacSQLString:self.textMaxCount.text];
    
    if ([rtStringCheck checkIsNotNull:strName] && [rtStringCheck checkNumber:strMaxCount]) {
        NSString *sqlstr;
        
        if ([self.formType isEqualToString:@"edit"]) {
            //儲存主表
            sqlstr = [NSString stringWithFormat:@"update `package_type` set `status`=%@,`name`='%@',`maxcount`=%@ where `sid`=%zd and `package_main_sid`=%zd",
                      strStatus,
                      strName,
                      strMaxCount,
                      self.typeID,
                      self.packageID];
            [rtDatabase sqlSub:sqlstr];
            
            //清空選項
            sqlstr = [NSString stringWithFormat:@"delete from `package_type_dishtype` where `package_type_sid`=%zd",self.typeID];
            [rtDatabase sqlSub:sqlstr];
            
            
        }else{
            //儲存主表
            sqlstr = [NSString stringWithFormat:@"insert into `package_type`(`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(%zd, %@, '%@', %@, 1)",
                      self.packageID,
                      strStatus,
                      strName,
                      strMaxCount];
            self.typeID = [rtDatabase sqlSubForAutoID:sqlstr];
        }
        
        for (NSDictionary *dic in dishtypeItemArray) {
            if ([[dic objectForKey:@"setting"] isEqualToString:@"1"]) {
                sqlstr = [NSString stringWithFormat:@"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(%zd, %@)",
                          self.typeID,
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
        
        sqlstr = [NSString stringWithFormat:@"delete from `package_type` where `sid`=%zd and `package_main_sid`=%zd",
                  self.typeID,
                  self.packageID];
        [rtDatabase sqlSub:sqlstr];
        
        sqlstr = [NSString stringWithFormat:@"delete from `package_type_dishtype` where `package_type_sid`=%zd",self.typeID];
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
    return dishtypeItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuPackageTypeFormCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuPackageTypeFormCell" forIndexPath:indexPath];
    cell.itemData = [dishtypeItemArray objectAtIndex:indexPath.row];
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
    [self.textMaxCount resignFirstResponder];
}
@end
