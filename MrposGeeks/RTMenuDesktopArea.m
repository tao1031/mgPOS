//
//  RTMenuDesktopArea.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDesktopArea.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuDesktopAreaForm.h"
#import "RTMenuDesktopDataForm.h"
#import "RTMenuDesktopAreaCell.h"

@interface RTMenuDesktopArea ()
{
    NSMutableArray *desktopItemArray;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    BOOL editStatus;  //編輯返回重新讀取
}
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RTMenuDesktopArea

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
    [self defDataLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (editStatus) {
        editStatus = NO;
        [self defDataLoad];
    }
}

-(void)defInit{
    rtDatabase = [[RTDatabaseCore alloc] init];
    rtStringCheck = [[RTStringCheck alloc] init];
    
    if (self.isOdd) {
        self.imgIcon.image = [UIImage imageNamed:@"05-table02"];
    }
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.6f]];
    [RTViewLayer viewCornerRadius:self.btnAdd];
    editStatus = NO;
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    // 讀取區域資料
    sqlstr = [NSString stringWithFormat:@"select * from `desktop_area` where `sid`=%zd",self.desktopAreaID];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    self.labelPrice.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"orderLowPrice", @"最低消費"),[rtStringCheck numberToString:[[mainDesktopAreaArray objectForKey:@"lowprice"] integerValue]]];
    
    // 讀取桌次資料
    sqlstr = [NSString stringWithFormat:@"select * from `desktop_data` where `desktop_area_sid`=%zd",self.desktopAreaID];
    desktopItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return desktopItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuDesktopAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuDesktopAreaCell" forIndexPath:indexPath];
    [cell updateView:[desktopItemArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    editStatus = YES;
    RTMenuDesktopDataForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDesktopDataForm"];
    detail.formType = @"edit";
    detail.desktopAreaID = self.desktopAreaID;
    detail.desktopDataID = [[[desktopItemArray objectAtIndex:indexPath.row] objectForKey:@"sid"] integerValue];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actThisSetting:(id)sender {
    editStatus = YES;
    RTMenuDesktopAreaForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDesktopAreaForm"];
    detail.desktopAreaID = self.desktopAreaID;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actAddItem:(id)sender {
    editStatus = YES;
    RTMenuDesktopDataForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDesktopDataForm"];
    detail.formType = @"add";
    detail.desktopAreaID = self.desktopAreaID;
    [self.navigationController pushViewController:detail animated:YES];
}
@end
