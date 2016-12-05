//
//  RTMenuDesktopAreaCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuDesktopAreaCell.h"
#import "RTViewLayer.h"

@interface RTMenuDesktopAreaCell ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@end

@implementation RTMenuDesktopAreaCell

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
