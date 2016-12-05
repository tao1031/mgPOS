//
//  RTMenuOrderDishTypeCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderDishTypeCell.h"
#import "RTViewLayer.h"

@interface RTMenuOrderDishTypeCell ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@end

@implementation RTMenuOrderDishTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [RTViewLayer viewCornerRadius:self.viewContent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView:(NSDictionary *)itemData  {
    self.labTitle.text = [itemData objectForKey:@"name"];
    self.labPrice.text = [itemData objectForKey:@"price"];
}

@end
