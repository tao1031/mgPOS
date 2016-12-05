//
//  RTNavigationChoosePackage.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTMenuOrderPackageChoose.h"

@interface RTNavigationChoosePackage : UINavigationController

@property (nonatomic, assign) NSMutableArray *orderData;
@property (nonatomic, assign) NSInteger packageID;
@property (nonatomic, assign) BOOL isInSide;
@property (nonatomic, assign) BOOL isOutSide;

@end
