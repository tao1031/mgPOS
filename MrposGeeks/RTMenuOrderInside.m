//
//  RTMenuOrderInside.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/29.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderInside.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTMenuOrderCheckoutSingleCell.h"
#import "RTMenuOrderCheckoutPackageCell.h"
#import "RTMenuOrderSingleDish.h"
#import "RTMenuOrderPackage.h"

@interface RTMenuOrderInside ()<RTMenuOrderSingleDishDelegate,RTMenuOrderPackageDelegate>
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    NSMutableArray *orderData;
    NSString *orderSid;
}
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labSubTotal;
@property (weak, nonatomic) IBOutlet UILabel *labSerivceTotal;
@property (weak, nonatomic) IBOutlet UILabel *labTotal;
@property (weak, nonatomic) IBOutlet UILabel *labOrderSid;
@property (weak, nonatomic) IBOutlet UILabel *labDesktopArea;
@property (weak, nonatomic) IBOutlet UILabel *labDesktopNum;
@property (weak, nonatomic) IBOutlet UILabel *labDesktopPrice;
@end

@implementation RTMenuOrderInside

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
    [self defDataLoad];
    [self resetOrder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)defInit{
    rtDatabase = [[RTDatabaseCore alloc] init];
    rtStringCheck = [[RTStringCheck alloc] init];
    orderData = [[NSMutableArray alloc] init];
    [self checkoutOrderTotal];
    [self.tableView setEstimatedRowHeight:85.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    self.labDesktopArea.text = self.desktopAreaString;
    self.labDesktopNum.text = self.desktopNumString;
    self.labDesktopPrice.text = self.desktopPriceString;
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    // 讀取套餐
    [self addPackage];
    
    // 讀取餐點類型
    sqlstr = @"select * from `dish_type` where `status`=1 order by `sort`, `sid` desc";
    NSArray *typeAreaArray = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *itemData in typeAreaArray) {
        [self addDishType:[[itemData objectForKey:@"sid"] integerValue]];
    }
}

-(void)resetOrder{
    //清空訂單
    [orderData removeAllObjects];
    [self.tableView reloadData];
    
    //訂單編號初始
    orderSid = @"0";
    self.labOrderSid.text = orderSid;
    
}

-(void)removeAllTableView{
    for (UIView *item in self.stackView.subviews) {
        [self.stackView removeArrangedSubview:item];
    }
    for (UIViewController *itemView in self.childViewControllers) {
        [itemView removeFromParentViewController];
    }
}

-(void)getNewOrderSid{
    NSString *desktop = @"";
    desktop = [NSString stringWithFormat:@"%@-%@",self.desktopAreaString,self.desktopNumString];
    NSString *sqlstr = @"";
    sqlstr = [NSString stringWithFormat:@"insert into orderdata(`desktop`,`orderdata`,`is_outside`,`is_upload`,`server_id`,`create_date`) values('%@', '', 0, 0, 0 ,'%@')",
              desktop,
              [rtStringCheck getNowDateString]];
    orderSid = [@([rtDatabase sqlSubForAutoID:sqlstr]) stringValue];
    self.labOrderSid.text = orderSid;
}

- (void)addPackage{
    RTMenuOrderPackage *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderPackage"];
    mainview.delegate = self;
    mainview.orderData = orderData;
    mainview.isInSide = YES;
    mainview.isOutSide = NO;
    [mainview.view.widthAnchor constraintEqualToConstant:200].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

- (void)addDishType:(NSInteger) dishTypeID{
    RTMenuOrderSingleDish *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderSingleDish"];
    mainview.delegate = self;
    mainview.orderData = orderData;
    mainview.dishTypeID = dishTypeID;
    mainview.isInSide = YES;
    mainview.isOutSide = NO;
    [mainview.view.widthAnchor constraintEqualToConstant:200].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

-(void)orderOutsideReload{
    [self.tableView reloadData];
    [self checkoutOrderTotal];

    if (orderData.count > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:orderData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)actCheckout:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [RTAlertView
     showAlert:NSLocalizedString(@"", @"")
     message:NSLocalizedString(@"orderIsCheckout", @"訂單完成結帳")
     button:NSLocalizedString(@"buttonSure", @"確定")
     ];
}

- (IBAction)actPrint:(id)sender {
    if ([orderSid isEqualToString:@"0"]) {
        [self getNewOrderSid];
    }
    NSData *orderJsonData = [NSJSONSerialization dataWithJSONObject:orderData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *orderJsonString = [[NSString alloc] initWithData:orderJsonData encoding:NSUTF8StringEncoding];
    
    NSString *sqlstr = @"";
    sqlstr = [NSString stringWithFormat:@"update orderdata set `orderdata`='%@' where `sid`=%@", orderJsonString, orderSid];
    [rtDatabase sqlSub:sqlstr];
    
    [RTAlertView
     showAlert:NSLocalizedString(@"", @"")
     message:NSLocalizedString(@"submitIsSuccess", @"送出成功")
     button:NSLocalizedString(@"buttonSure", @"確定")
     ];
}

-(void)checkoutOrderTotal{
    //計算訂單金額
    NSInteger orderItemTotal = 0;
    for (NSDictionary *orderItem in orderData) {
        NSInteger orderItemSubTotal = 0;
        if ([[orderItem objectForKey:@"itemType"] isEqualToString:@"package"]) {
            orderItemSubTotal += [[orderItem objectForKey:@"packagePrice"] integerValue];
            for (NSString *packageDataTypeKey in [orderItem objectForKey:@"packageData"]) {
                NSDictionary *packageTypeData = [[orderItem objectForKey:@"packageData"] objectForKey:packageDataTypeKey];
                for (NSString *packageDataKey in packageTypeData) {
                    NSDictionary *packageData = [packageTypeData objectForKey:packageDataKey];
                    orderItemSubTotal += [[packageData objectForKey:@"dishPrice"] integerValue];
                    for (NSDictionary *dishOption in [packageData objectForKey:@"dishOption"]) {
                        orderItemSubTotal += [[dishOption objectForKey:@"price"] integerValue];
                    }
                }
            }
        }else{
            orderItemSubTotal += [[orderItem objectForKey:@"dishPrice"] integerValue];
            for (NSDictionary *optionItem in [orderItem objectForKey:@"dishOption"]) {
                orderItemSubTotal += [[optionItem objectForKey:@"price"] integerValue];
            }
        }
        orderItemTotal += orderItemSubTotal;
    }
    self.labSubTotal.text = [rtStringCheck numberToString:orderItemTotal];
    NSInteger serivceTotal = (int)orderItemTotal / 10;
    self.labSerivceTotal.text = [rtStringCheck numberToString:serivceTotal];
    self.labTotal.text = [rtStringCheck numberToString:(orderItemTotal+serivceTotal)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[orderData objectAtIndex:[indexPath row]] objectForKey:@"itemType"] isEqualToString:@"package"]) {
        RTMenuOrderCheckoutPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderCheckoutPackageCell" forIndexPath:indexPath];
        [cell updateView:[orderData objectAtIndex:indexPath.row]];
        return cell;
    }else{
        RTMenuOrderCheckoutSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderCheckoutSingleCell" forIndexPath:indexPath];
        [cell updateView:[orderData objectAtIndex:indexPath.row]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"wordDelete", @"删除");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [orderData removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self checkoutOrderTotal];
}
@end
