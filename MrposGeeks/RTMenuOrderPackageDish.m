//
//  RTMenuOrderPackageDish.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderPackageDish.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuOrderDishTypeCell.h"
#import "RTMenuOrderPackageDishOption.h"

@interface RTMenuOrderPackageDish ()<RTMenuOrderPackageDishOptionDelegate>
{
    NSMutableArray *dishItemArray;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RTMenuOrderPackageDish

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
    sqlstr = [NSString stringWithFormat:@"select * from `dish_type` where `sid`=%zd",self.packageDishType];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    
    // 讀取詳細資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_data` where `dish_type_sid`=%zd",self.packageDishType];
    if (self.isInSide) {
        sqlstr = [NSString stringWithFormat:@"%@ and `isinside`=1",sqlstr];
    }
    if (self.isOutSide) {
        sqlstr = [NSString stringWithFormat:@"%@ and `isoutside`=1",sqlstr];
    }
    dishItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];

    // 剔除不在此選單內項目
    sqlstr = [NSString stringWithFormat:@"select * from `package_type_detail` where  `package_type_sid`=%zd",self.packageTypeID];
    NSMutableArray *settingItem = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    for (int i=0; i<dishItemArray.count; i++) {
        BOOL removeTag = YES;
        for (int j=0; j<settingItem.count; j++) {
            if ([[[dishItemArray objectAtIndex:i] objectForKey:@"sid"] isEqualToString:[[settingItem objectAtIndex:j] objectForKey:@"dish_data_sid"]]) {
                [[dishItemArray objectAtIndex:i] setObject:[[settingItem objectAtIndex:j] objectForKey:@"addprice"] forKey:@"price"]; //更新加價購金額
                removeTag = NO;
            }
        }
        if (removeTag) {
            [dishItemArray removeObjectAtIndex:i];
            i--;
        }
    }
    
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
        [orderDish setObject:[[dishItemArray objectAtIndex:[indexPath row]] objectForKey:@"name"] forKey:@"dishTitle"];
        [orderDish setObject:[[dishItemArray objectAtIndex:[indexPath row]] objectForKey:@"price"] forKey:@"dishPrice"];
        
        if (![self.orderPackageData objectForKey:self.orderPackageTypeKey]) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            [self.orderPackageData setObject:tempDic forKey:self.orderPackageTypeKey];
        }
        NSMutableDictionary *packageTypeLevel = [self.orderPackageData objectForKey:self.orderPackageTypeKey];
        [packageTypeLevel setObject:orderDish forKey:self.orderPackageKey];
        [self.orderPackageData setObject:packageTypeLevel forKey:self.orderPackageTypeKey];
        [self.choosePackageData setObject:[[dishItemArray objectAtIndex:[indexPath row]] objectForKey:@"name"] forKey:@"title"];
        [self orderPackageDishReload];
    }else{
        RTMenuOrderPackageDishOption *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderPackageDishOption"];
        detail.delegate = self;
        detail.dishItem = [dishItemArray objectAtIndex:[indexPath row]];
        detail.orderPackageTypeKey = self.orderPackageTypeKey;
        detail.orderPackageKey = self.orderPackageKey;
        detail.choosePackageData = self.choosePackageData;
        detail.orderPackageData = self.orderPackageData;
        detail.modalPresentationStyle = UIModalPresentationCustom;
        detail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:detail animated:YES completion: nil];
    }
}

-(void)orderPackageDishReload{
    [self.delegate orderPackageChooseReload];
}

@end
