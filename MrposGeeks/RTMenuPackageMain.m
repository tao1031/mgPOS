//
//  RTMenuPackageMain.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageMain.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuPackageMainCell.h"
#import "RTMenuPackageMainForm.h"
#import "RTMenuPackageTypeForm.h"

@interface RTMenuPackageMain ()
{
    NSMutableArray *typeItemArray;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    BOOL editStatus;  //編輯返回重新讀取
}
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RTMenuPackageMain

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
    [self.tableView setEstimatedRowHeight:80.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    editStatus = NO;
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    // 讀取套餐資料
    sqlstr = [NSString stringWithFormat:@"select * from `package_main` where `sid`=%zd",self.packageID];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    
    // 讀取詳細資料
    sqlstr = [NSString stringWithFormat:@"select * from `package_type` where `package_main_sid`=%zd",self.packageID];
    typeItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return typeItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuPackageMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuPackageMainCell" forIndexPath:indexPath];
    cell.itemData = [typeItemArray objectAtIndex:indexPath.row];
    cell.mainNavigation = self.navigationController;
    [cell updateView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    editStatus = YES;
    RTMenuPackageTypeForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuPackageTypeForm"];
    detail.formType = @"edit";
    detail.packageID = self.packageID;
    detail.typeID = [[[typeItemArray objectAtIndex:indexPath.row] objectForKey:@"sid"] integerValue];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actThisSetting:(id)sender {
    editStatus = YES;
    RTMenuPackageMainForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuPackageMainForm"];
    detail.packageID = self.packageID;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actAddItem:(id)sender {
    editStatus = YES;
    RTMenuPackageTypeForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuPackageTypeForm"];
    detail.formType = @"add";
    detail.packageID = self.packageID;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
