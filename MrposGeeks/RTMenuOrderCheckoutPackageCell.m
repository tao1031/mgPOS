//
//  RTMenuOrderCheckoutPackageCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/27.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderCheckoutPackageCell.h"
#import "RTStringCheck.h"
#import "RTMenuOrderViewItem.h"
#import "RTMenuOrderViewPackageType.h"
#import "RTMenuOrderViewPackageDish.h"

@interface RTMenuOrderCheckoutPackageCell ()
{
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation RTMenuOrderCheckoutPackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self defInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)defInit{
    rtStringCheck = [[RTStringCheck alloc] init];
}

- (void)updateView:(NSDictionary *)itemData{
    self.labTitle.text = [itemData objectForKey:@"packageTitle"];
    self.labPrice.text = [rtStringCheck numberToString:[[itemData objectForKey:@"packagePrice"] integerValue]];

    //暫時無法處理因記憶體重複增加問題，先以run time 移除subview方法解決
    for (UIView *itemView in self.stackView.arrangedSubviews) {
        [itemView removeFromSuperview];
        [self.stackView removeArrangedSubview:itemView];
    }
    
    for (NSString *packageDataKey in [itemData objectForKey:@"packageData"]) {
        NSDictionary *packageDataType = [[itemData objectForKey:@"packageData"] objectForKey:packageDataKey];
        [self addType:packageDataType setTitle:packageDataKey];
    }
}

- (void)addType:(NSDictionary *) packageDataType setTitle:(NSString *)title{
    UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuOrder" bundle:nil];
    RTMenuOrderViewPackageType *mainview = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuOrderViewPackageType"];
    [mainview.view.widthAnchor constraintEqualToConstant:230].active = true;
    mainview.labTitle.text = title;
    [self.stackView addArrangedSubview:mainview.viewContent];
    for (NSString *packageDishKey in packageDataType) {
        [self addDish:[packageDataType objectForKey:packageDishKey]];
    }
}

- (void)addDish:(NSDictionary *) dishItem{
    UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuOrder" bundle:nil];
    RTMenuOrderViewPackageDish *mainview = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuOrderViewPackageDish"];
    [mainview.view.widthAnchor constraintEqualToConstant:230].active = true;
    mainview.labTitle.text = [NSString stringWithFormat:@"%@",[dishItem objectForKey:@"dishTitle"]];
    mainview.labPrice.text = [NSString stringWithFormat:@"%@",[dishItem objectForKey:@"dishPrice"]];
    [self.stackView addArrangedSubview:mainview.viewContent];
    for (NSDictionary *dishOption in [dishItem objectForKey:@"dishOption"]) {
        [self addOption:dishOption];
    }
}

- (void)addOption:(NSDictionary *) optionItem{
    UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuOrder" bundle:nil];
    RTMenuOrderViewItem *mainview = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuOrderViewItem"];
    [mainview.view.widthAnchor constraintEqualToConstant:230].active = true;
    mainview.labTitle.text = [NSString stringWithFormat:@"%@:%@",[optionItem objectForKey:@"mainName"],[optionItem objectForKey:@"name"]];
    mainview.labPrice.text = [rtStringCheck numberToString:[[optionItem objectForKey:@"price"] integerValue]];
    [self.stackView addArrangedSubview:mainview.viewContent];
}
@end
