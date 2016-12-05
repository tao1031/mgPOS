//
//  RTMenuOrderDishType.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTMenuOrderSingleDishDelegate
@required
- (void)orderOutsideReload;
@end


@interface RTMenuOrderSingleDish : UIViewController

@property (nonatomic, assign) NSMutableArray *orderData;
@property (nonatomic, assign) NSInteger dishTypeID;
@property (nonatomic, assign) BOOL isInSide;
@property (nonatomic, assign) BOOL isOutSide;
@property (weak) id<RTMenuOrderSingleDishDelegate> delegate;

@end
