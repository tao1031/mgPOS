//
//  RTMenuOrderArea.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/20.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderArea.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTViewLayer.h"
#import "RTMenuOrderAreaCellOn.h"
#import "RTMenuOrderAreaCellOff.h"
#import "RTMenuOrderInside.h"

@interface RTMenuOrderArea ()
{
    NSMutableArray *desktopItemArray;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@end

@implementation RTMenuOrderArea

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
    
    if (self.isOdd) {
        self.imgIcon.image = [UIImage imageNamed:@"05-table02"];
    }
    [self.tableView setEstimatedRowHeight:44.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:1.0f]];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    // 讀取區域資料
    sqlstr = [NSString stringWithFormat:@"select * from `desktop_area` where `sid`=%zd",self.desktopAreaID];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    self.labelPrice.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"orderLowPrice", @"最低消費"),[rtStringCheck numberToString:[[mainDesktopAreaArray objectForKey:@"lowprice"] integerValue]]];
    
    // 讀取桌次資料
    sqlstr = [NSString stringWithFormat:@"select * from `desktop_data` where `status`=1 and `desktop_area_sid`=%zd",self.desktopAreaID];
    desktopItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return desktopItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuOrderAreaCellOff *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderAreaCellOff" forIndexPath:indexPath];
    [cell updateView:[desktopItemArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RTMenuOrderInside *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderInside"];
    NSDictionary *itemDic = [desktopItemArray objectAtIndex:indexPath.row];
    detail.desktopAreaString = self.labelTitle.text;
    detail.desktopPriceString = self.labelPrice.text;
    detail.desktopNumString = [itemDic objectForKey:@"name"];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
