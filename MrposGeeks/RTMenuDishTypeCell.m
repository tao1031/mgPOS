//
//  RTDishTypeTitleCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/19.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDishTypeCell.h"
#import "RTViewLayer.h"

@interface RTMenuDishTypeCell ()

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;

@end

@implementation RTMenuDishTypeCell

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
