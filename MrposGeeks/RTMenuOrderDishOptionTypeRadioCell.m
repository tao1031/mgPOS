//
//  RTMenuOrderDishOptionTypeCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderDishOptionTypeRadioCell.h"

@interface RTMenuOrderDishOptionTypeRadioCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgRadio;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@end

@implementation RTMenuOrderDishOptionTypeRadioCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView:(NSDictionary *)itemData  {
    if ([[itemData objectForKey:@"choosing"] isEqualToString:@"0"]) {
        self.imgRadio.image = [UIImage imageNamed:@"radio-order02"];
    }else{
        self.imgRadio.image = [UIImage imageNamed:@"radio-order01"];
    }
    self.labTitle.text = [itemData objectForKey:@"name"];
    self.labPrice.text = [itemData objectForKey:@"price"];
}

@end
