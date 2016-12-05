//
//  RTMenuOrderDishOptionType.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderSingleDishOptionType.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTMenuOrderDishOptionTypeCheckCell.h"
#import "RTMenuOrderDishOptionTypeRadioCell.h"

@interface RTMenuOrderSingleDishOptionType ()
{
    NSMutableArray *optionItemArray;
    NSMutableArray *reloadData;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    BOOL isMultiplechoose;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RTMenuOrderSingleDishOptionType

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
    reloadData = [[NSMutableArray alloc] init];
    
    [self.tableView setEstimatedRowHeight:44.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    // 讀取類型資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_option_type` where `sid`=%zd",self.optionID];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    isMultiplechoose = ([[mainDesktopAreaArray objectForKey:@"multiplechoose"] isEqualToString:@"1"]) ? YES : NO;
    
    // 讀取詳細資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_option_data` where `dish_option_type_sid`=%zd",self.optionID];
    optionItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    int reloadCount = -1;
    for (NSMutableDictionary *item in optionItemArray) {
        [item setObject:@"0" forKey:@"choosing"];
        reloadCount++;
        [reloadData addObject:[NSIndexPath indexPathForRow:reloadCount inSection:0]];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return optionItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isMultiplechoose){
        RTMenuOrderDishOptionTypeCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderDishOptionTypeCheckCell" forIndexPath:indexPath];
        [cell updateView:[optionItemArray objectAtIndex:indexPath.row]];
        return cell;
    }else{
        RTMenuOrderDishOptionTypeRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderDishOptionTypeRadioCell" forIndexPath:indexPath];
        [cell updateView:[optionItemArray objectAtIndex:indexPath.row]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *itemKey = [NSString stringWithFormat:@"%@",[[optionItemArray objectAtIndex:[indexPath row]] objectForKey:@"sid"]];
    if(isMultiplechoose){
        if ([[[optionItemArray objectAtIndex:[indexPath row]] objectForKey:@"choosing"] isEqualToString:@"1"]) {
            [[optionItemArray objectAtIndex:[indexPath row]] setObject:@"0" forKey:@"choosing"];
            [self.chooseItem removeObjectForKey:itemKey];
        }else{
            [[optionItemArray objectAtIndex:[indexPath row]] setObject:@"1" forKey:@"choosing"];
            [self.chooseItem setObject:@"1" forKey:itemKey];
        }
    }else{
        for (NSMutableDictionary *item in optionItemArray) {
            [item setObject:@"0" forKey:@"choosing"];
        }
        [[optionItemArray objectAtIndex:[indexPath row]] setObject:@"1" forKey:@"choosing"];
        [self.chooseItem removeAllObjects];
        [self.chooseItem setObject:@"1" forKey:itemKey];
    }
    [tableView reloadRowsAtIndexPaths:reloadData withRowAnimation:UITableViewRowAnimationFade];
}


@end
