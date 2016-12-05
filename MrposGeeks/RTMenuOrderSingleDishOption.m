//
//  RTMenuOrderDishOption.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderSingleDishOption.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTMenuOrderSingleDishOptionType.h"

@interface RTMenuOrderSingleDishOption ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    NSDictionary *optionDataArray;
    NSMutableDictionary *chooseItemArray;
}
@property (weak, nonatomic) IBOutlet UILabel *labDishName;
@property (weak, nonatomic) IBOutlet UIView *viewConfBtn;
@property (weak, nonatomic) IBOutlet UIView *viewDish;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation RTMenuOrderSingleDishOption

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
    chooseItemArray = [[NSMutableDictionary alloc] init];
    
    [RTViewLayer viewCornerRadius:self.viewDish];
    [RTViewLayer viewCornerBorderWidth:self.viewConfBtn setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.viewConfBtn setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
}

-(void)defDataLoad{
    NSString *sqlstr = @"";

    //讀取菜色資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_data` where `sid`=%@",self.dishID];
    optionDataArray = [rtDatabase selectSubForFirst:sqlstr];
    self.labDishName.text = [optionDataArray objectForKey:@"name"];
    
    // 讀取選項資料
    sqlstr = [NSString stringWithFormat:@"select * from `dish_data_option` where `dish_data_sid`=%@",self.dishID];
    NSArray *optionArray = [rtDatabase selectSub:sqlstr];
    for (NSDictionary *itemData in optionArray) {
        [self addDishOptionType:[[itemData objectForKey:@"dish_option_type_sid"] integerValue]];
    }
}

- (void)addDishOptionType:(NSInteger) optionID{
    RTMenuOrderSingleDishOptionType *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuOrderSingleDishOptionType"];
    [chooseItemArray setObject:[[NSMutableDictionary alloc] init] forKey:[NSString stringWithFormat:@"%zd",optionID]];
    mainview.chooseItem = [chooseItemArray objectForKey:[NSString stringWithFormat:@"%zd",optionID]];
    mainview.optionID = optionID;
    [mainview.view.widthAnchor constraintEqualToConstant:200].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

- (IBAction)actAdd:(id)sender {
    NSMutableDictionary *orderDish = [[NSMutableDictionary alloc] init];
    [orderDish setObject:@"single" forKey:@"itemType"];
    [orderDish setObject:[optionDataArray objectForKey:@"name"] forKey:@"dishTitle"];
    [orderDish setObject:[optionDataArray objectForKey:@"price"] forKey:@"dishPrice"];
    NSMutableArray *dishOption = [[NSMutableArray alloc] init];
    NSString *sqlstr = @"";
    for (NSMutableDictionary *itemMain in chooseItemArray) {
        for (NSMutableDictionary *itemDetail in [chooseItemArray objectForKey:itemMain]) {
            sqlstr = [NSString stringWithFormat:@"select * from `dish_option_data` where `sid`=%@",itemDetail];
            NSMutableDictionary *detailResult = [[rtDatabase selectSubForFirst:sqlstr] mutableCopy];
            sqlstr = [NSString stringWithFormat:@"select * from `dish_option_type` where `sid`=%@",[detailResult objectForKey:@"dish_option_type_sid"]];
            NSDictionary *mainResult = [rtDatabase selectSubForFirst:sqlstr];
            [detailResult setObject:[mainResult objectForKey:@"name"] forKey:@"mainName"];            
            [dishOption addObject:detailResult];
        }
    }
    [orderDish setObject:dishOption forKey:@"dishOption"];
    
    if (orderDish.count > 0) {
        [self.orderData addObject:orderDish];
    }
    
    [self.delegate orderSingleDishReload];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actCancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
