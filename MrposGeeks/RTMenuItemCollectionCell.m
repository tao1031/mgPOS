//
//  RTMenuItemCollectionCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/20.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuItemCollectionCell.h"
#import "RTViewLayer.h"

@interface RTMenuItemCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@end

@implementation RTMenuItemCollectionCell

- (void)updateView:(NSDictionary *)cellData  {
    [RTViewLayer viewCornerBorderWidth:self.viewContent setBorderWidth:2];
    [RTViewLayer viewCornerBorderColor:self.viewContent setBorderColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
    [RTViewLayer viewCornerRadius:self.viewContent];
    
    NSString *title = [cellData objectForKey:@"title"];
    self.labTitle.text = NSLocalizedString(title, title);
    
    NSString *imgUrl = [cellData objectForKey:@"icon"];
    self.imgIcon.image = [UIImage imageNamed:imgUrl];
}
@end
