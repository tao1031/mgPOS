//
//  RTMenuCollection.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/20.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <REFrostedViewController.h>

@protocol RTMenuCollectionDelegate <NSObject>

@required
- (void)menuDidSelected:(NSDictionary *)menu;
- (void)menuDidLogout;
@end

@interface RTMenuCollection : UIViewController
@property (strong, nonatomic) NSMutableArray *menuItemData;
@property (nonatomic, weak) id <RTMenuCollectionDelegate> delegate;
@end
