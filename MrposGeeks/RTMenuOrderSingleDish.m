//
//  RTMenuOrderDishType.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderSingleDish.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuOrderDishTypeCell.h"
#import "RTMenuOrderSingleDishOption.h"

@interface RTMenuOrderSingleDish ()<RTMenuOrderSingleDishOptionDelegate>
{
    NSMutableArray *dishItemArray;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RTMenuOrderSingleDish

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
    
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:1.0f]];
    [self.tableView setEstimatedRowHeight:60.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    // 讀取類型資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_type` where `sid`=%zd",self.dishTypeID];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    
    // 讀取詳細資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_data` where `dish_type_sid`=%zd",self.dishTypeID];
    if (self.isInSide) {
        sqlstr = [NSString stringWithFormat:@"%@ and `isinside`=1",sqlstr];
    }
    if (self.isOutSide) {
        sqlstr = [NSString stringWithFormat:@"%@ and `isoutside`=1",sqlstr];
    }
    dishItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dishItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuOrderDishTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderDishTypeCell" forIndexPath:indexPath];
    [cell updateView:[dishItemArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sid = [[dishItemArray objectAtIndex:[indexPath row]] objectForKey:@"sid"];
    NSString *sqlstr = [NSString stringWithFormat:@"select * from `dish_data_option` where `dish_data_sid`=%@",sid];
    NSArray *optionArray = [rtDatabase selectSub:sqlstr];
    if (optionArray.count==0) {
        NSMutableDictionary *orderDish = [[NSMutableDictionary alloc] init];
        [orderDish setObject:@"single" forKey:@"itemType"];
        [orderDish setObject:[[dishItemArray objectAtIndex:[indexPath row]] objectForKey:@"name"] forKey:@"dishTitle"];
        [orderDish setObject:[[dishItemArray objectAtIndex:[indexPath row]] objectForKey:@"price"] forKey:@"dishPrice"];
        [self.orderData addObject:orderDish];
        [self orderSingleDishReload];
    }else{
        RTMenuOrderSingleDishOption *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderSingleDishOption"];
        detail.delegate = self;
        detail.orderData = self.orderData;
        detail.dishID = [[dishItemArray objectAtIndex:[indexPath row]] objectForKey:@"sid"];
        detail.modalPresentationStyle = UIModalPresentationCustom;
        detail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:detail animated:YES completion: nil];
    }
}

-(void)orderSingleDishReload{
    [self.delegate orderOutsideReload];
}

@end
