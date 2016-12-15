//
//  RTMenuDesktopAreaCell.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "boardDataMgr.h"

@interface RTMenuDesktopAreaCell : UITableViewCell

- (void)updateView:(NSDictionary *)itemData;
- (void)updateViewByTableData:(tableData *)itemData;

@end
