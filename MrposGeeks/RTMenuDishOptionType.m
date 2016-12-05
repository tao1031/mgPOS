//
//  RTMenuDishOptionList.m
//  MrposGeeks
//
//  Created by Vexon Elite on 2016/9/9.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDishOptionType.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuDishOptionTypeForm.h"
#import "RTMenuDishOptionDataForm.h"
#import "RTMenuDishOptionTypeCell.h"

@interface RTMenuDishOptionType ()
{
    NSMutableArray *optionItemArray;
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

@implementation RTMenuDishOptionType

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
    sqlstr = [NSString stringWithFormat:@"select * from `dish_option_type` where `sid`=%zd",self.dishOptionID];
    NSDictionary *mainDesktopAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainDesktopAreaArray objectForKey:@"name"];
    
    // 讀取詳細資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_option_data` where `dish_option_type_sid`=%zd",self.dishOptionID];
    optionItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return optionItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuDishOptionTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuDishOptionTypeCell" forIndexPath:indexPath];
    [cell updateView:[optionItemArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    editStatus = YES;
    RTMenuDishOptionDataForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishOptionDataForm"];
    detail.formType = @"edit";
    detail.optionTypeID = self.dishOptionID;
    detail.optionDataID = [[[optionItemArray objectAtIndex:indexPath.row] objectForKey:@"sid"] integerValue];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actThisSetting:(id)sender {
    editStatus = YES;
    RTMenuDishOptionTypeForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishOptionTypeForm"];
    detail.optionTypeID = self.dishOptionID;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)actAddItem:(id)sender {
    editStatus = YES;
    RTMenuDishOptionDataForm *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuDishOptionDataForm"];
    detail.formType = @"add";
    detail.optionTypeID = self.dishOptionID;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
