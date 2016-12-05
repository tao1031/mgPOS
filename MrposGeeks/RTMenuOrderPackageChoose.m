//
//  RTMenuOrderPackageChoose.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderPackageChoose.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTViewLayer.h"
#import "RTMenuOrderPackageCellTitle.h"
#import "RTMenuOrderPackageCellChoose.h"
#import "RTMenuOrderPackageDish.h"

@interface RTMenuOrderPackageChoose ()<RTMenuOrderPackageDishDelegate>
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    NSMutableArray *choosePackageData;
    NSMutableDictionary *orderPackageData;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIView *viewConfBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation RTMenuOrderPackageChoose

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
    choosePackageData = [[NSMutableArray alloc] init];
    orderPackageData = [[NSMutableDictionary alloc] init];
    
    [RTViewLayer viewCornerBorderWidth:self.viewConfBtn setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.viewConfBtn setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [self.tableView setEstimatedRowHeight:60.0f];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    
    sqlstr = [NSString stringWithFormat:@"select * from `package_main` where `status`=1 and `sid`=%zd",self.packageID];
    NSDictionary *mainArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labelTitle.text = [mainArray objectForKey:@"name"];
    self.labelPrice.text = [mainArray objectForKey:@"price"];

    sqlstr = [NSString stringWithFormat:@"select * from `package_type` where `status`=1 and `package_main_sid`=%zd order by sort",self.packageID];
    NSArray *result = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *packageType in result) {
        NSMutableDictionary *titleDic = [[NSMutableDictionary alloc] init];
        [titleDic setObject:@"title" forKey:@"type"];
        [titleDic setObject:[packageType objectForKey:@"name"] forKey:@"title"];
        [choosePackageData addObject:titleDic];
        
        sqlstr = [NSString stringWithFormat:@"select * from `package_type_dishtype` where `package_type_sid`=%@",[packageType objectForKey:@"sid"]];
        NSArray *resultDishType = [rtDatabase selectSub:sqlstr];
        NSMutableArray *packageDishType = [[NSMutableArray alloc] init];
        for (NSDictionary *dishDic in resultDishType) {
            [packageDishType addObject:[dishDic objectForKey:@"dish_type_sid"]];
        }
        for (int i=0; i<[[packageType objectForKey:@"maxcount"] integerValue]; i++) {
            NSMutableDictionary *packageTypeItem = [[NSMutableDictionary alloc] init];
            [packageTypeItem setObject:@"packageType" forKey:@"type"];
            [packageTypeItem setObject:[packageType objectForKey:@"name"] forKey:@"mainType"];
            [packageTypeItem setObject:NSLocalizedString(@"wordPleaseChoose", @"請選擇") forKey:@"title"];
            
            [packageTypeItem setObject:[@(self.packageID) stringValue]  forKey:@"packageID"];
            [packageTypeItem setObject:[packageType objectForKey:@"sid"] forKey:@"packageTypeID"];
            [packageTypeItem setObject:packageDishType forKey:@"packageDishType"];
            [choosePackageData addObject:packageTypeItem];
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return choosePackageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[choosePackageData objectAtIndex:[indexPath row]] objectForKey:@"type"] isEqualToString:@"title"]) {
        RTMenuOrderPackageCellTitle *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderPackageCellTitle" forIndexPath:indexPath];
        [cell updateView:[choosePackageData objectAtIndex:[indexPath row]]];
        return cell;
    }else{
        RTMenuOrderPackageCellChoose *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuOrderPackageCellChoose" forIndexPath:indexPath];
        [cell updateView:[choosePackageData objectAtIndex:[indexPath row]]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *selectItem = [choosePackageData objectAtIndex:[indexPath row]];
    if ([[selectItem objectForKey:@"type"] isEqualToString:@"packageType"]) {
        [self removeAllTableView];
        for (NSString *packageDishType in [selectItem objectForKey:@"packageDishType"]) {
            NSMutableDictionary *setChoosePackageType = [[NSMutableDictionary alloc] init];
            
            [setChoosePackageType setObject:[selectItem objectForKey:@"mainType"] forKey:@"mainType"];
            [setChoosePackageType setObject:[selectItem objectForKey:@"packageID"] forKey:@"packageID"];
            [setChoosePackageType setObject:[selectItem objectForKey:@"packageTypeID"] forKey:@"packageTypeID"];
            [setChoosePackageType setObject:packageDishType forKey:@"packageDishType"];
            [self addDishType:setChoosePackageType setIndexPathRow:[indexPath row]];
        }
    }
}

-(void)removeAllTableView{
    for (UIView *item in self.stackView.subviews) {
        [self.stackView removeArrangedSubview:item];
    }
    for (UIViewController *itemView in self.childViewControllers) {
        [itemView removeFromParentViewController];
    }
}

- (void)addDishType:(NSDictionary *) setChoosePackageType setIndexPathRow:(NSInteger)indexPathRow{
    RTMenuOrderPackageDish *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderPackageDish"];
    mainview.delegate = self;
    mainview.orderPackageTypeKey = [setChoosePackageType objectForKey:@"mainType"];
    mainview.orderPackageKey = [@(indexPathRow) stringValue];
    mainview.orderPackageData = orderPackageData;
    mainview.choosePackageData = [choosePackageData objectAtIndex:indexPathRow];
    mainview.packageID = [[setChoosePackageType objectForKey:@"packageID"] integerValue];
    mainview.packageTypeID = [[setChoosePackageType objectForKey:@"packageTypeID"] integerValue];
    mainview.packageDishType = [[setChoosePackageType objectForKey:@"packageDishType"] integerValue];
    mainview.isInSide = self.isInSide;
    mainview.isOutSide = self.isOutSide;
    [mainview.view.widthAnchor constraintEqualToConstant:200].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

- (IBAction)actAdd:(id)sender {
    NSMutableDictionary *orderPackageDataMain = [[NSMutableDictionary alloc] init];
    [orderPackageDataMain setObject:self.labelTitle.text forKey:@"packageTitle"];
    [orderPackageDataMain setObject:self.labelPrice.text forKey:@"packagePrice"];
    [orderPackageDataMain setObject:@"package" forKey:@"itemType"];
    [orderPackageDataMain setObject:orderPackageData forKey:@"packageData"];
    [self.orderData addObject:orderPackageDataMain];
    [self.delegate orderOutsidePackageReload];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actCancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)orderPackageChooseReload{
    [self removeAllTableView];
    [self.tableView reloadData];
}

@end
