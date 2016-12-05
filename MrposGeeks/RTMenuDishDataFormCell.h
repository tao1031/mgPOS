//
//  RTMenuDishDataFormCell.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTMenuDishDataFormCell : UITableViewCell

- (void)updateView;
@property (nonatomic, retain) NSMutableDictionary *itemData;

@end
