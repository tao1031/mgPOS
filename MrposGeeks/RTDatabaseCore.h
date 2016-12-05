//
//  RTDatabaseCore.h
//
//  Created by 任昌 陳 on 2016/8/31.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface RTDatabaseCore : NSObject

- (void)initialized;
- (void)sqlSub:(NSString *)sqlString;
- (NSInteger)sqlSubForAutoID:(NSString *)sqlString;
- (NSArray*)selectSub:(NSString *)sqlString;
- (NSDictionary*)selectSubForFirst:(NSString *)sqlString;
- (BOOL)deleteDB;
- (NSString*)replacSQLString:(NSString *)sqlString;
@end
