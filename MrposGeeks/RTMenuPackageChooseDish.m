//
//  RTMenuPackageChooseDish.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageChooseDish.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "RTAlertView.h"
#import "RTMenuPackageChooseDishType.h"

@interface RTMenuPackageChooseDish ()
{
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    NSMutableDictionary *chooseItemArray;
}
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation RTMenuPackageChooseDish

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
}

-(void)defDataLoad{
    NSString *sqlstr = @"";
    // 讀取套餐類型資料
    sqlstr = [NSString stringWithFormat:@"select * from `package_type` where `sid`=%zd",self.typeID];
    NSDictionary *typeAreaArray = [rtDatabase selectSubForFirst:sqlstr];
    if ([rtStringCheck checkNumber:[typeAreaArray objectForKey:@"sid"]]) {
        self.navigationItem.title = [typeAreaArray objectForKey:@"name"];
        sqlstr = [NSString stringWithFormat:@"select * from `package_type_dishtype` where `package_type_sid`=%zd",self.typeID];
        NSArray *chooseTypeArray = [rtDatabase selectSub:sqlstr];
        for (NSDictionary *dic in chooseTypeArray) {
            sqlstr = [NSString stringWithFormat:@"select * from `dish_data` where `status`=1 and `dish_type_sid`=%@",[dic objectForKey:@"dish_type_sid"]];
            NSArray *defDishArray = [rtDatabase selectSub:sqlstr];

            
            sqlstr = [NSString stringWithFormat:@"select * from `package_type_detail` where `package_type_sid`=%zd",self.typeID];
            NSArray *defSettingArray = [rtDatabase selectSub:sqlstr];
            
            for (NSMutableDictionary *itemDic in defDishArray) {
                [itemDic setObject:@"0" forKey:@"setting"];
                [itemDic setObject:@"0" forKey:@"addPrice"];
                for (NSMutableDictionary *settingDic in defSettingArray) {
                    if ([[settingDic objectForKey:@"dish_data_sid"] isEqualToString:[itemDic objectForKey:@"sid"]]) {
                        [itemDic setObject:@"1" forKey:@"setting"];
                        [itemDic setObject:[settingDic objectForKey:@"addprice"] forKey:@"addPrice"];
                    }
                }
            }
            
            [chooseItemArray setObject:defDishArray forKey:[dic objectForKey:@"dish_type_sid"]];
        }
    }else{
        [RTAlertView
         showAlert:NSLocalizedString(@"", @"")
         message:NSLocalizedString(@"dataIsNull", @"資料不存在")
         button:NSLocalizedString(@"buttonSure", @"確定")
         ];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    for (NSString *itemKey in chooseItemArray) {
        [self addPackageMain:itemKey];
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

- (void)addPackageMain:(NSString*) typeID{
    RTMenuPackageChooseDishType *mainview = [self.storyboard instantiateViewControllerWithIdentifier:@"RTMenuPackageChooseDishType"];
    mainview.itemArray = [chooseItemArray objectForKey:typeID];
    [mainview.view.widthAnchor constraintEqualToConstant:250].active = true;
    [self.stackView addArrangedSubview:mainview.view];
    [self addChildViewController:mainview];
}

- (IBAction)actSave:(id)sender {
    NSString *sqlstr = @"";
    sqlstr = [NSString stringWithFormat:@"delete from `package_type_detail` where `package_type_sid`=%zd",self.typeID];
    [rtDatabase sqlSub:sqlstr];
    
    for (NSString *key in chooseItemArray) {
        for (NSDictionary *dic in [chooseItemArray objectForKey:key]) {
            if ([[dic objectForKey:@"setting"] isEqualToString:@"1"]) {
                sqlstr = [NSString stringWithFormat:@"insert into `package_type_detail`(`package_type_sid`,`dish_data_sid`,`status`,`addprice`) values(%zd,%@,1,%@)",
                                                    self.typeID,
                                                    [dic objectForKey:@"sid"],
                                                    [dic objectForKey:@"addPrice"]
                                                    ];
                [rtDatabase sqlSub:sqlstr];
            }
        }
    }
    [RTAlertView
     showAlert:NSLocalizedString(@"", @"")
     message:NSLocalizedString(@"saveIsSuccess", @"儲存成功")
     button:NSLocalizedString(@"buttonSure", @"確定")
     ];
}

@end
