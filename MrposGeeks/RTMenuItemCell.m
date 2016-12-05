//
//  RTMenuItemCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/18.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuItemCell.h"

@interface RTMenuItemCell ()
    @property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
    @property (weak, nonatomic) IBOutlet UILabel *labTitle;
@end

@implementation RTMenuItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateView:(NSDictionary *)cellData  {
    NSString *title = [cellData objectForKey:@"title"];
    self.labTitle.text = NSLocalizedString(title, title);
    
    NSString *imgUrl = [cellData objectForKey:@"icon"];
    self.imgIcon.image = [UIImage imageNamed:imgUrl];
}
@end
