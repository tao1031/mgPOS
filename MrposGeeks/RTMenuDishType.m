//
//  RTMenuDishTypeTable.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/19.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDishType.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuDishTypeForm.h"
#import "RTMenuDishDataForm.h"
#import "RTMenuDishTypeCell.h"

@interface RTMenuDishType ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dishItemArray;
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

@implementation RTMenuDishType

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

    [self.tableView setEstimatedRowHeight:44.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    editStatus = NO;
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    // 讀取類型資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_type` where `sid`=%zd",self.dishTypeID];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    
    // 讀取詳細資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_data` where `dish_type_sid`=%zd",self.dishTypeID];
    dishItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dishItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuDishTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuDishTypeCell" forIndexPath:indexPath];
    [cell updateView:[dishItemArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    editStatus = YES;
    RTMenuDishDataForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishDataForm"];
    detail.formType = @"edit";
    detail.dishTypeID = self.dishTypeID;
    detail.dishDataID = [[[dishItemArray objectAtIndex:indexPath.row] objectForKey:@"sid"] integerValue];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actThisSetting:(id)sender {
    editStatus = YES;
    RTMenuDishTypeForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishTypeForm"];
    detail.typeID = self.dishTypeID;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actAddItem:(id)sender {
    editStatus = YES;
    RTMenuDishDataForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishDataForm"];
    detail.formType = @"add";
    detail.dishTypeID = self.dishTypeID;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
