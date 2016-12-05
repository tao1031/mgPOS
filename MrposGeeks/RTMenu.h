//
//  RTMenuTableViewController.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/18.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <REFrostedViewController.h>

@protocol MenuDelegate <NSObject>

@required
    - (void)menuDidSelected:(NSDictionary *)menu;
@end

@interface RTMenu : UITableViewController
    @property (strong, nonatomic) NSMutableArray *menuItemData;
    @property (nonatomic, weak) id <MenuDelegate> delegate;
@end
