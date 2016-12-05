//
//  RTMenuOrderPackageDishOption.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTMenuOrderPackageDishOptionDelegate
@required
- (void)orderPackageDishReload;
@end

@interface RTMenuOrderPackageDishOption : UIViewController

@property (nonatomic, assign) NSMutableDictionary *dishItem;
@property (nonatomic, assign) NSString *orderPackageTypeKey;
@property (nonatomic, assign) NSString *orderPackageKey;
@property (nonatomic, assign) NSMutableDictionary *choosePackageData;
@property (nonatomic, assign) NSMutableDictionary *orderPackageData;

@property (weak) id<RTMenuOrderPackageDishOptionDelegate> delegate;

@end
