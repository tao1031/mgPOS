//
//  RTMenuPackageTypeCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageTypeFormCell.h"

@interface RTMenuPackageTypeFormCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@end

@implementation RTMenuPackageTypeFormCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView{
    self.switchStatus.on = ([[self.itemData objectForKey:@"setting"] isEqualToString:@"1"]) ? YES : NO;
    self.labTitle.text = [self.itemData objectForKey:@"name"];
}

- (IBAction)actSwitch:(id)sender {
    (self.switchStatus.on) ? [self.itemData setObject:@"1" forKey:@"setting"] : [self.itemData setObject:@"0" forKey:@"setting"];
}

@end