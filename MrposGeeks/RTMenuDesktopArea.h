//
//  RTMenuDesktopArea.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/1.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeesionAuthUIViewController.h"
#import "boardDataMgr.h"

@interface RTMenuDesktopArea : UIViewController

@property (nonatomic, assign) NSInteger desktopAreaID;
@property (nonatomic, assign) BOOL isOdd;
#ifdef REMOTE_DATA
@property (nonatomic, retain) areaData *aData;
#endif
@end
