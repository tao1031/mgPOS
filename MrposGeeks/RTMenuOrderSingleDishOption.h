//
//  RTMenuOrderDishOption.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTMenuOrderSingleDishOptionDelegate
@required
- (void)orderSingleDishReload;
@end

@interface RTMenuOrderSingleDishOption : UIViewController

@property (nonatomic, assign) NSMutableArray *orderData;
@property (nonatomic, assign) NSString *dishID;
@property (weak) id<RTMenuOrderSingleDishOptionDelegate> delegate;

@end
