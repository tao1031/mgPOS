//
//  RTMenuPackageMainCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageMainCell.h"
#import "RTMenuPackageChooseDish.h"
#import "RTViewLayer.h"

@interface RTMenuPackageMainCell ()

@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labMaxcount;

@end

@implementation RTMenuPackageMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [RTViewLayer viewCornerRadius:self.viewContent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateView{
    self.labTitle.text = [self.itemData objectForKey:@"name"];
    self.labMaxcount.text = [self.itemData objectForKey:@"maxcount"];
}

- (IBAction)actChooseItem:(id)sender {
    UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuPackage" bundle:nil];
    RTMenuPackageChooseDish *detail = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuPackageChooseDish"];
    detail.typeID = [[self.itemData objectForKey:@"sid"] integerValue];
    [self.mainNavigation pushViewController:detail animated:YES];
}

@end
