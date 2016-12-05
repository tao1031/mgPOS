//
//  RTMenuOrderPackageChoose.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//
//選擇套餐各分類

#import <UIKit/UIKit.h>

@protocol RTMenuOrderPackageChooseDelegate
@required
- (void)orderOutsidePackageReload;

@end

@interface RTMenuOrderPackageChoose : UIViewController

@property (nonatomic, assign) NSMutableArray *orderData;
@property (nonatomic, assign) NSInteger packageID;
@property (nonatomic, assign) BOOL isInSide;
@property (nonatomic, assign) BOOL isOutSide;
@property (weak) id<RTMenuOrderPackageChooseDelegate> delegate;

@end
