//
//  RTMenuOrderPackage.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/21.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RTMenuOrderPackageDelegate
@required
- (void)orderOutsideReload;
@end

@interface RTMenuOrderPackage : UIViewController

@property (nonatomic, assign) NSMutableArray *orderData;
@property (nonatomic, assign) BOOL isInSide;
@property (nonatomic, assign) BOOL isOutSide;
@property (weak) id<RTMenuOrderPackageDelegate> delegate;

@end
