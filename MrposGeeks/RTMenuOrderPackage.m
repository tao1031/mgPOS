//
//  RTMenuOrderPackage.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//
#import "RTMenuOrderPackage.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuOrderPackageCell.h"
#import "RTNavigationChoosePackage.h"
#import "RTMenuOrderPackageChoose.h"

@interface RTMenuOrderPackage ()<RTMenuOrderPackageChooseDelegate>
{
    NSMutableArray *packageItemArray;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RTMenuOrderPackage

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
    // 讀取詳細資料
    NSString *sqlstr = @"";
    sqlstr = [NSString stringWithFormat:@"select * from `package_main` where `status`=1"];
    packageItemArray = [NSMutableArray arrayWithArray:[rtDatabase selectSub:sqlstr]];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return packageItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuOrderPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderPackageCell" forIndexPath:indexPath];
    [cell updateView:[packageItemArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RTNavigationChoosePackage *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"RTNavigationChoosePackage"];
    detail.orderData = self.orderData;
    detail.isInSide = self.isInSide;
    detail.isOutSide = self.isOutSide;
    detail.packageID = [[[packageItemArray objectAtIndex:[indexPath row]] objectForKey:@"sid"] integerValue];
    detail.modalPresentationStyle = UIModalPresentationCustom;
    detail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:detail animated:YES completion: nil];
    
    RTMenuOrderPackageChoose *detailFirst = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderPackageChoose"];
    detailFirst = detail.viewControllers.firstObject;
    detailFirst.delegate = self;

}

-(void)orderOutsidePackageReload{
    [self.delegate orderOutsideReload];
}
@end
