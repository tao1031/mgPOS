//
//  RTNavigationChoosePackage.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/26.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTNavigationChoosePackage.h"


@interface RTNavigationChoosePackage ()

@end

@implementation RTNavigationChoosePackage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)defInit{
    RTMenuOrderPackageChoose *detail = self.viewControllers.firstObject;
    detail.orderData = self.orderData;
    detail.packageID = self.packageID;
    detail.isInSide = self.isInSide;
    detail.isOutSide = self.isOutSide;
}
@end
