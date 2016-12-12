//
//  RTLoginUserCell.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/2.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "accountDataMgr.h"

@interface RTLoginUserCell : UICollectionViewCell

- (void)updateView:(NSDictionary *)itemData;
- (void)updateViewByAccountData:(accountData *)itemData;

@end
