//
//  RTMenuDishOptionCell.m
//  MrposGeeks
//
//  Created by Vexon Elite on 2016/9/9.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDishOptionTypeCell.h"
#import "RTViewLayer.h"

@interface RTMenuDishOptionTypeCell ()

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;

@end

@implementation RTMenuDishOptionTypeCell

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
