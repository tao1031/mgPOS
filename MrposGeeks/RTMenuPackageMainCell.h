//
//  RTMenuPackageMainCell.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTMenuPackageMainCell : UITableViewCell

- (void)updateView;
@property (nonatomic, retain) NSMutableDictionary *itemData;
@property (nonatomic, retain) UINavigationController *mainNavigation;

@end
