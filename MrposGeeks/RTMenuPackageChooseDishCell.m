//
//  RTMenuPackageChooseDishCell.m
//  MrposGeeks
//
//  Created by Tseng To-Cheng on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageChooseDishCell.h"
#import "RTViewLayer.h"

@interface RTMenuPackageChooseDishCell ()

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UITextField *textPrice;

@end

@implementation RTMenuPackageChooseDishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [RTViewLayer viewCornerRadius:self.viewContent];
    [RTViewLayer viewCornerBorderWidth:self.textPrice setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textPrice setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView{
    self.switchStatus.on = ([[self.itemData objectForKey:@"setting"] isEqualToString:@"1"]) ? YES : NO;
    self.labTitle.text = [self.itemData objectForKey:@"name"];
    self.textPrice.text = [self.itemData objectForKey:@"addPrice"];
}

- (IBAction)actSwitch:(id)sender {
    (self.switchStatus.on) ? [self.itemData setObject:@"1" forKey:@"setting"] : [self.itemData setObject:@"0" forKey:@"setting"];
}

- (IBAction)textFieldDidChange:(id)sender {
    self.textPrice.text = [NSString stringWithFormat:@"%zd",[self.textPrice.text integerValue]];    
    [self.itemData setObject:self.textPrice.text forKey:@"addPrice"];
}


@end
