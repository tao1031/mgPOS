//
//  accountDataMgr.m
//  MrposGeeks
//
//  Created by Admin on 2016/12/8.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "accountDataMgr.h"

@implementation accountDataMgr
@synthesize accountAry;

+ (id)instance {
    static accountDataMgr *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (id)init {
    if (self = [super init]) {
        accountAry = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end

@implementation accountData
@synthesize accountId, name, photoUrl;
@end
