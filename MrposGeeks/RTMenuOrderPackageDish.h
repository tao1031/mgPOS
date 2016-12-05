//
//  RTMenuOrderPackageDish.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//
//選擇套餐各分類項目

#import <UIKit/UIKit.h>

@protocol RTMenuOrderPackageDishDelegate
@required
-(void)orderPackageChooseReload;
@end

@interface RTMenuOrderPackageDish : UIViewController

@property (nonatomic, assign) NSString *orderPackageTypeKey;
@property (nonatomic, assign) NSString *orderPackageKey;
@property (nonatomic, assign) NSMutableDictionary *choosePackageData;
@property (nonatomic, assign) NSMutableDictionary *orderPackageData;

@property (nonatomic, assign) NSInteger packageID;
@property (nonatomic, assign) NSInteger packageTypeID;
@property (nonatomic, assign) NSInteger packageDishType;

@property (nonatomic, assign) BOOL isInSide;
@property (nonatomic, assign) BOOL isOutSide;
@property (weak) id<RTMenuOrderPackageDishDelegate> delegate;

@end
