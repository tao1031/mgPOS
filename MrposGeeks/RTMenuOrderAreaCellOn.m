//
//  RTMenuOrderAreaCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/20.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderAreaCellOn.h"
#import "RTViewLayer.h"

@interface RTMenuOrderAreaCellOn ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@end

@implementation RTMenuOrderAreaCellOn

- (void)awakeFromNib {
    [super awakeFromNib];
    [RTViewLayer viewCornerRadius:self.viewContent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView:(NSDictionary *)itemData  {
    self.labTitle.text = [NSString stringWithFormat:@"%@-%@%@",[itemData objectForKey:@"name"],[itemData objectForKey:@"maxpeople"],NSLocalizedString(@"unitPeople", @"人")];
}
@end
