//
//  RTMenuOrderDishOptionTypeCheckCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderDishOptionTypeCheckCell.h"

@interface RTMenuOrderDishOptionTypeCheckCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@end

@implementation RTMenuOrderDishOptionTypeCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView:(NSDictionary *)itemData  {
    if ([[itemData objectForKey:@"choosing"] isEqualToString:@"0"]) {
        self.imgCheck.image = [UIImage imageNamed:@"checkbox-order02"];
    }else{
        self.imgCheck.image = [UIImage imageNamed:@"checkbox-order01"];
    }
    self.labTitle.text = [itemData objectForKey:@"name"];
    self.labPrice.text = [itemData objectForKey:@"price"];
}

@end
