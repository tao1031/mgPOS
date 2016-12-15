//
//  boardDataMgr.m
//  MrposGeeks
//
//  Created by Admin on 2016/12/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "boardDataMgr.h"

@implementation boardDataMgr
@synthesize areaAry;

+ (id)instance {
    static boardDataMgr *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (id)init {
    if (self = [super init]) {
        areaAry = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end


@implementation areaData
@synthesize areaId, areaName, areaNotice, enable, tableAry;

- (id)init {
    if (self = [super init]) {
        tableAry = [[NSMutableArray alloc]init];
    }
    return self;
}
@end


@implementation tableData
@synthesize areaId, tabldId, tableName, enable, capacity;
@end
