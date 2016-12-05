//
//  RTMenuOrderPackageCellChoose.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuOrderPackageCellChoose.h"
#import "RTViewLayer.h"

@interface RTMenuOrderPackageCellChoose ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@end

@implementation RTMenuOrderPackageCellChoose

- (void)awakeFromNib {
    [super awakeFromNib];
     [RTViewLayer viewCornerRadius:self.viewContent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView:(NSDictionary *)itemData  {
    self.labTitle.text = [itemData objectForKey:@"title"];
}
@end
