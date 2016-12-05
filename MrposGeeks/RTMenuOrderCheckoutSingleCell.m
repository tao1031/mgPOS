//
//  RTMenuOrderCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/23.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderCheckoutSingleCell.h"
#import "RTStringCheck.h"
#import "RTMenuOrderViewItem.h"

@interface RTMenuOrderCheckoutSingleCell ()
{
    RTStringCheck *rtStringCheck;
}
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@end

@implementation RTMenuOrderCheckoutSingleCell

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
    self.labTitle.text = [itemData objectForKey:@"dishTitle"];
    self.labPrice.text = [rtStringCheck numberToString:[[itemData objectForKey:@"dishPrice"] integerValue]];
    
    //暫時無法處理因記憶體重複增加問題，先以run time 移除subview方法解決
    for (UIView *itemView in self.stackView.arrangedSubviews) {
        [itemView removeFromSuperview];
        [self.stackView removeArrangedSubview:itemView];
    }

    for (NSDictionary *optionItem in [itemData objectForKey:@"dishOption"]) {
        [self addOption:optionItem];
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
