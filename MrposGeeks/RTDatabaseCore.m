//
//  RTDatabaseCore.m
//
//  Created by 任昌 陳 on 2016/8/31.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//
#import "RTDatabaseCore.h"
#import <sqlite3.h>

@interface RTDatabaseCore ()
{
    NSString *dbVersion;
    NSString *dbName;
    sqlite3 *database;
}
@end

@implementation RTDatabaseCore


- (id)init{
    dbVersion = @"0.1.0";
    dbName = @"RTTestSqlite.db";
    database = nil;
    return self;
}

- (void)initialized{
    // 資料庫結構
    NSArray *initDatabaseSQLArray =
        [NSArray arrayWithObjects:
            @"CREATE TABLE IF NOT EXISTS db_version (vid INTEGER PRIMARY KEY, version_num varchar(255))",
            @"CREATE TABLE IF NOT EXISTS roles (rid INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(255))",
            @"CREATE TABLE IF NOT EXISTS users (uid INTEGER PRIMARY KEY AUTOINCREMENT, status INTEGER, name varchar(255) UNIQUE, pwd varchar(255), nickname varchar(255), userimage varchar(255), role INTEGER, sort INTEGER )",
            @"CREATE TABLE IF NOT EXISTS desktop_area (sid INTEGER PRIMARY KEY AUTOINCREMENT, status INTEGER, name varchar(255), lowprice INTEGER, sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS desktop_data (sid INTEGER PRIMARY KEY AUTOINCREMENT, desktop_area_sid INTEGER, status INTEGER, name varchar(255), maxpeople INTEGER, sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS dish_option_type (sid INTEGER PRIMARY KEY AUTOINCREMENT, status INTEGER, name varchar(255), multiplechoose INTEGER, sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS dish_option_data (sid INTEGER PRIMARY KEY AUTOINCREMENT, dish_option_type_sid INTEGER, status INTEGER, name varchar(255), price INTEGER, sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS dish_type (sid INTEGER PRIMARY KEY AUTOINCREMENT, status INTEGER, name varchar(255), sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS dish_data (sid INTEGER PRIMARY KEY AUTOINCREMENT, dish_type_sid INTEGER, status INTEGER, name varchar(255), price INTEGER, isinside INTEGER, isoutside INTEGER, sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS dish_data_option (dish_data_sid INTEGER, dish_option_type_sid INTEGER)",
            @"CREATE TABLE IF NOT EXISTS package_main (sid INTEGER PRIMARY KEY AUTOINCREMENT, status INTEGER, name varchar(255), price INTEGER, sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS package_type (sid INTEGER PRIMARY KEY AUTOINCREMENT, package_main_sid INTEGER, status INTEGER, name varchar(255), maxcount INTEGER, sort INTEGER)",
            @"CREATE TABLE IF NOT EXISTS package_type_dishtype (package_type_sid INTEGER, dish_type_sid INTEGER)",
            @"CREATE TABLE IF NOT EXISTS package_type_detail (package_type_sid INTEGER, dish_data_sid INTEGER, status INTEGER, addprice INTEGER)",
            @"CREATE TABLE IF NOT EXISTS orderdata (sid INTEGER PRIMARY KEY AUTOINCREMENT, desktop varchar(255), orderdata text, is_outside INTEGER, is_upload INTEGER, server_id INTEGER, create_date varchar(255))",

         
            //@"CREATE TABLE IF NOT EXISTS member (id INTEGER PRIMARY KEY AUTOINCREMENT, rtname TEXT, company TEXT)",
            nil
        ];
    NSString *initDatabaseSQL = @"";
    for (NSString *sqlItem in initDatabaseSQLArray) {
        initDatabaseSQL = [NSString stringWithFormat:@"%@%@;",initDatabaseSQL,sqlItem];
    }
    
    [self open];
    char *errorMsg;
    if (database != nil) {
        const char *createSQL = [initDatabaseSQL UTF8String];
        if (sqlite3_exec(database, createSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            sqlite3_free(errorMsg);
        }
    }
    [self close];
    NSLog(@"initDatabaseError:%s",errorMsg);
    
    // 預設資料
    NSArray *defDataDatabaseSQLArray =
        [NSArray arrayWithObjects:
            [NSString stringWithFormat:@"insert into db_version(`vid`,`version_num`) values(1,'%@')",dbVersion],
         @"insert into roles(`rid`,`name`) values(1,'店長')",
         @"insert into roles(`rid`,`name`) values(2,'櫃檯')",
         @"insert into roles(`rid`,`name`) values(3,'店員')",
         @"insert into users(`uid`,`status`,`name`,`pwd`,`nickname`,`userimage`,`role`,`sort`) values(1, 1, 'admin','e10adc3949ba59abbe56e057f20f883e','admin','01_defaultphoto',1,1)",
         @"insert into users(`uid`,`status`,`name`,`pwd`,`nickname`,`userimage`,`role`,`sort`) values(2, 1, 'alan' ,'e10adc3949ba59abbe56e057f20f883e','alan' ,'01_defaultphoto',1,1)",
         @"insert into users(`uid`,`status`,`name`,`pwd`,`nickname`,`userimage`,`role`,`sort`) values(3, 1, 'toren','e10adc3949ba59abbe56e057f20f883e','toren','01_defaultphoto',2,1)",
         @"insert into users(`uid`,`status`,`name`,`pwd`,`nickname`,`userimage`,`role`,`sort`) values(4, 1, 'andy' ,'e10adc3949ba59abbe56e057f20f883e','andy' ,'01_defaultphoto',3,1)",
         @"insert into users(`uid`,`status`,`name`,`pwd`,`nickname`,`userimage`,`role`,`sort`) values(5, 1, 'zoe' ,'e10adc3949ba59abbe56e057f20f883e','zoe' ,'01_defaultphoto',3,1)",
         
         @"insert into `dish_option_type`(`sid`,`status`,`name`,`multiplechoose`,`sort`) values(1, 1, '冰塊', 0,1)",
         @"insert into `dish_option_type`(`sid`,`status`,`name`,`multiplechoose`,`sort`) values(2, 1, '辣度', 0,1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(1, 1, '正常', 0, 1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(1, 1, '少冰', 0, 1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(1, 1, '微冰', 0, 1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(1, 1, '去冰', 0, 1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(2, 1, '正常', 0, 1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(2, 1, '中辣', 0, 1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(2, 1, '小辣', 0, 1)",
         @"insert into `dish_option_data`(`dish_option_type_sid`,`status`,`name`,`price`,`sort`) values(2, 1, '微辣', 0, 1)",
         
         @"insert into `desktop_area`(`sid`,`status`,`name`,`lowprice`,`sort`) values(1,1,'一樓','1000',1)",
         @"insert into `desktop_area`(`sid`,`status`,`name`,`lowprice`,`sort`) values(2,1,'二樓','2000',1)",
         @"insert into `desktop_area`(`sid`,`status`,`name`,`lowprice`,`sort`) values(3,1,'三樓','3999',1)",
         @"insert into `desktop_area`(`sid`,`status`,`name`,`lowprice`,`sort`) values(4,1,'包廂','5000',1)",
         @"insert into `desktop_area`(`sid`,`status`,`name`,`lowprice`,`sort`) values(5,1,'VIP','9999',1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(1, 1, 'A1', 4, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(1, 1, 'A2', 4, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(1, 1, 'A3', 4, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(1, 1, 'A4', 4, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(2, 1, 'B1', 2, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(2, 1, 'B2', 2, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(2, 1, 'B3', 6, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(2, 1, 'B4', 6, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(3, 1, 'C1', 8, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(3, 1, 'C2', 8, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(3, 1, 'C3', 8, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(3, 1, 'C4', 8, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(4, 1, 'A', 10, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(4, 1, 'B', 10, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(4, 1, 'C', 10, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(4, 1, 'D', 10, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(4, 1, 'E', 10, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(4, 1, 'F', 10, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(5, 1, 'V1-1', 2, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(5, 1, 'V1-2', 2, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(5, 1, 'V1-3', 2, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(5, 1, 'V1-4', 2, 1)",
         @"insert into `desktop_data`(`desktop_area_sid`,`status`,`name`,`maxpeople`,`sort`) values(5, 1, 'V1-5', 2, 1)",
         
         
         
         
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(1,1,'鍋類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(2,1,'免費款待',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(3,1,'老四川小菜專區',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(4,1,'特別菜色',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(5,1,'肉類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(6,1,'海鮮',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(7,1,'蔬菜',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(8,1,'菇類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(9,1,'餃類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(10,1,'丸子',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(11,1,'漿類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(12,1,'乾料類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(13,1,'滷類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(14,1,'飲料',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(15,1,'酒類',1)",
         @"insert into `dish_type`(`sid`,`status`,`name`,`sort`) values(16,1,'沾醬及物料',1)",
         
         
         
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(1, 1, '雙味鴛鴦鍋', 0, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(1, 1, '絕選辣味鍋', 0, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(1, 1, '養生白為鍋', 0, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(2, 1, '八寶茶', 0, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(2, 1, '開胃小菜', 0, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(2, 1, '川味涼粉', 0, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(2, 1, '古早味刨冰', 0, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(3, 1, '薄片脆耳', 65, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(4, 1, '川味涼粉', 110, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(4, 1, '川味酥肉(豬肉)', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(4, 1, '蜀香排骨酥', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(4, 1, '鴨腸', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(4, 1, '牛百頁', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '頂級美國和牛', 1800, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '頂級4A牛肉', 600, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '頂級安格斯無骨牛小排', 440, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '精選特級雪花牛肉', 380, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '精選五花牛肉', 300, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '骰子牛肉', 280, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '豬頸花肉', 320, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '健康五花豬肉', 290, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '梅花豬肉', 280, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '澳洲小羔羊', 320, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '羊肩肉卷', 280, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '珍品雞胗卷', 230, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(5, 1, '特選去骨雞肉', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '總匯海鮮', 850, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '海鮮拼盤', 560, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '帆立貝', 230, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '軟絲', 210, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '大明蝦(一隻)', 145, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '花蟹', 390, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '海蝦', 320, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '鮑魚', 280, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '鯛魚', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '小卷', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '蟹腿', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(6, 1, '花枝', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '蔬菜拚盤', 180, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '高麗菜', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '大白菜', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '白玉蘿蔔', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '大陸妹', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '青江菜', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '娃娃菜', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '茼蒿', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '木耳', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '玉米', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '冬瓜', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '絲瓜', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '馬鈴薯', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '綿芋頭', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(7, 1, '紅心蕃薯', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(8, 1, '菇類拼盤', 260, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(8, 1, '鴻喜菇', 180, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(8, 1, '杏鮑菇', 180, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(8, 1, '金針菇', 125, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(8, 1, '秀珍菇', 125, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(8, 1, '香菇', 125, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(8, 1, '珊瑚菇', 125, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(9, 1, '餃類拼盤', 180, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(9, 1, '魚餃', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(9, 1, '燕餃', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(9, 1, '蝦餃', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(9, 1, '蛋餃', 95, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '豬肉川丸子', 175, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '干貝丸', 260, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '手工丸子拼盤', 240, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '丸子拼盤', 220, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '牛肉川丸子', 175, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '花枝丸', 175, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '香菇旗魚丸', 175, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '手工魚丸', 175, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(10, 1, '手工鮮蝦丸', 175, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(11, 1, '蝦仁漿', 260, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(11, 1, '蟹黃漿', 260, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(11, 1, '花枝漿', 260, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(11, 1, '魚漿', 220, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(12, 1, '稻菊天婦羅', 110, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(12, 1, '寬粉', 70, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(12, 1, '油條', 70, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(12, 1, '豆皮', 70, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(12, 1, '米血', 70, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(12, 1, '年糕片', 70, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(13, 1, '滷水拼盤', 450, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(13, 1, '滷水小拼盤', 340, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(13, 1, '滷水大腸頭', 250, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(13, 1, '滷水牛肚', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(13, 1, '滷水牛筋', 190, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(14, 1, '烏梅汁', 130, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(14, 1, '楊桃酸梅汁', 130, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(14, 1, '開喜烏龍茶', 55, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(14, 1, '老四川瓶裝飲用水', 10, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(14, 1, '蘋果西打', 40, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(14, 1, '可樂', 25, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(14, 1, '雪碧', 25, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '麥卡倫', 1600, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '蘇格登', 1500, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '金門高粱酒', 500, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '八八坑道', 900, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '海尼根', 135, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '百威啤酒', 110, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '金牌台灣啤酒', 110, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(15, 1, '麒麟啤酒', 110, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(16, 1, '風味沾醬', 10, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(16, 1, '風味芝麻醬', 10, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(16, 1, '蔥段', 35, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(16, 1, '蒜苗段', 35, 1, 1, 1)",
         @"insert into `dish_data`(`dish_type_sid`,`status`,`name`,`price`,`isinside`,`isoutside`,`sort`) values(16, 1, '蒜頭', 35, 1, 1, 1)",
         
         @"insert into `package_main`(`sid`,`status`,`name`,`price`,`sort`) values(1,1,'三人同行餐A',999,1)",
         @"insert into `package_main`(`sid`,`status`,`name`,`price`,`sort`) values(2,1,'三人同行餐B',999,1)",
         @"insert into `package_main`(`sid`,`status`,`name`,`price`,`sort`) values(3,1,'成雙成對餐A',1234,1)",
         @"insert into `package_main`(`sid`,`status`,`name`,`price`,`sort`) values(4,1,'成雙成對餐B',1234,1)",
         @"insert into `package_main`(`sid`,`status`,`name`,`price`,`sort`) values(5,1,'外帶套餐(牛肉)',1288,1)",
         @"insert into `package_main`(`sid`,`status`,`name`,`price`,`sort`) values(6,1,'外帶套餐(豬肉)',1199,1)",
         
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(1, 1, 1, '鍋類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(2, 1, 1, '肉類', 2, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(3, 1, 1, '菇類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(4, 1, 1, '丸子', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(5, 1, 1, '餃類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(6, 1, 1, '乾料類', 2, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(7, 1, 1, '蔬菜', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(8, 1, 1, '特別菜色', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(9, 1, 1, '免費款待', 4, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(10, 2, 1, '鍋類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(11, 2, 1, '肉類', 2, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(12, 2, 1, '丸子', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(13, 2, 1, '乾料類', 4, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(14, 2, 1, '蔬菜', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(15, 2, 1, '菇類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(16, 2, 1, '免費款待', 4, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(17, 3, 1, '鍋類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(18, 3, 1, '肉類', 2, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(19, 3, 1, '菇類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(20, 3, 1, '乾料類', 2, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(21, 3, 1, '蔬菜', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(22, 3, 1, '滷類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(23, 3, 1, '餃類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(24, 3, 1, '漿類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(25, 3, 1, '特別菜色', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(26, 3, 1, '丸子', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(27, 3, 1, '免費款待', 4, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(28, 4, 1, '鍋類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(29, 4, 1, '肉類', 2, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(30, 4, 1, '乾料類', 4, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(31, 4, 1, '蔬菜', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(32, 4, 1, '滷類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(33, 4, 1, '菇類', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(34, 4, 1, '海鮮', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(35, 4, 1, '丸子', 1, 1)",
         @"insert into `package_type`(`sid`,`package_main_sid`,`status`,`name`,`maxcount`,`sort`) values(36, 4, 1, '免費款待', 4, 1)",
         
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(1, 1)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(2, 5)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(3, 8)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(4, 10)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(5, 9)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(6, 12)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(7, 7)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(8, 4)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(9, 2)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(10, 1)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(11, 5)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(12, 10)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(13, 12)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(14, 7)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(15, 8)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(16, 2)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(17, 1)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(18, 5)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(19, 8)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(20, 12)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(21, 7)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(22, 13)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(23, 9)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(24, 11)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(25, 4)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(26, 10)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(27, 2)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(28, 1)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(29, 5)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(30, 12)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(31, 7)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(32, 13)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(33, 8)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(34, 6)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(35, 10)",
         @"insert into `package_type_dishtype`(`package_type_sid`,`dish_type_sid`) values(36, 2)",
            nil
        ];
    NSString *defDataDatabaseSQL = @"";
    for (NSString *sqlItem in defDataDatabaseSQLArray) {
        defDataDatabaseSQL = [NSString stringWithFormat:@"%@%@;",defDataDatabaseSQL,sqlItem];
    }
    [self sqlSub:defDataDatabaseSQL];
    
    
    
    NSString *sqlstr = @"select * from package_type_dishtype";
    NSArray *package_type_dishtype = [self selectSub:sqlstr];
    
    for (int i=0; i<package_type_dishtype.count; i++) {
        sqlstr = [NSString stringWithFormat:@"select * from dish_data where dish_type_sid=%@",[[package_type_dishtype objectAtIndex:i] objectForKey:@"dish_type_sid"]];
        NSArray *dish_data = [self selectSub:sqlstr];
        for (int j=0; j<dish_data.count; j++) {
            sqlstr = [NSString stringWithFormat:@"insert into `package_type_detail`(`package_type_sid`,`dish_data_sid`,`status`,`addprice`) values(%@, %@, 1, 0)",
                      [[package_type_dishtype objectAtIndex:i] objectForKey:@"package_type_sid"],
                      [[dish_data objectAtIndex:j] objectForKey:@"sid"]];
            [self sqlSub:sqlstr];
        }
    }
    
    sqlstr = @"select * from dish_data where dish_type_sid=1";
    NSArray *dish_data_1 = [self selectSub:sqlstr];
    for (int i=0; i<dish_data_1.count; i++) {
        sqlstr = [NSString stringWithFormat:@"insert into `dish_data_option`(`dish_data_sid`,`dish_option_type_sid`) values(%@, 2)",
                  [[dish_data_1 objectAtIndex:i] objectForKey:@"sid"]
                  ];
        [self sqlSub:sqlstr];
    }
    
    
    
    sqlstr = @"select * from dish_data where dish_type_sid=14";
    NSArray *dish_data_14 = [self selectSub:sqlstr];
    for (int i=0; i<dish_data_14.count; i++) {
        sqlstr = [NSString stringWithFormat:@"insert into `dish_data_option`(`dish_data_sid`,`dish_option_type_sid`) values(%@, 1)",
                  [[dish_data_14 objectAtIndex:i] objectForKey:@"sid"]
                  ];
        [self sqlSub:sqlstr];
    }
    
    
    sqlstr = @"select * from dish_data where dish_type_sid=15";
    NSArray *dish_data_15 = [self selectSub:sqlstr];
    for (int i=0; i<dish_data_15.count; i++) {
        sqlstr = [NSString stringWithFormat:@"insert into `dish_data_option`(`dish_data_sid`,`dish_option_type_sid`) values(%@, 1)",
                  [[dish_data_15 objectAtIndex:i] objectForKey:@"sid"]
                  ];
        [self sqlSub:sqlstr];
    }
    
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"DatabaseInit"];
    [defaults setObject:dbVersion forKey:@"DatabaseVersion"];
    [defaults synchronize];
}

- (BOOL)open{
    NSArray *dbFolderPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbFilePath = [[dbFolderPath objectAtIndex:0] stringByAppendingPathComponent:dbName];
    return (sqlite3_open([dbFilePath UTF8String], &database) == SQLITE_OK);
}

- (void)close{
    if (database != nil) {
        sqlite3_close(database);
    }
}

- (void)sqlSub:(NSString *)sqlString{
    [self open];
    char *errorMsg;
    if (database != nil) {
        const char *insertSQL = [sqlString UTF8String];
        if (sqlite3_exec(database, insertSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            sqlite3_free(errorMsg);
        }
    }
    NSLog(@"sqlsubErrorMsg:%s",errorMsg);
    [self close];
}

- (NSInteger)sqlSubForAutoID:(NSString *)sqlString{
    NSInteger autoID=0;
    [self open];
    char *errorMsg;
    if (database != nil) {
        const char *insertSQL = [sqlString UTF8String];
        if (sqlite3_exec(database, insertSQL, NULL, NULL, &errorMsg) == SQLITE_OK) {
            autoID = (NSInteger)sqlite3_last_insert_rowid(database);
        }else{
            sqlite3_free(errorMsg);
            return 0;
        }
    }
    [self close];
    NSLog(@"sqlsubErrorForAutoIDMsg:%s",errorMsg);
    return autoID;
}

- (NSArray*)selectSub:(NSString *)sqlString{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [self open];
    if (database != nil) {
        sqlite3_stmt *statement = nil;
        const char *selectSQL = [sqlString UTF8String];
        if (sqlite3_prepare_v2(database, selectSQL, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *itemData = [[NSMutableDictionary alloc] init];
                int fieldCount = sqlite3_data_count(statement);
                for (int i=0; i<fieldCount; i++) {
                    NSString *fieldName = [NSString stringWithFormat:@"%s", sqlite3_column_name(statement, i)];
                    NSString *fieldValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                    [itemData setObject:fieldValue forKey:fieldName];
                }
                [dataArray addObject:itemData];
            }
        }
        sqlite3_finalize(statement);
    }
    [self close];
    return [NSArray arrayWithArray:dataArray];
}

- (NSDictionary*)selectSubForFirst:(NSString *)sqlString{
    NSMutableDictionary *dataArray = [[NSMutableDictionary alloc] init];
    [self open];
    if (database != nil) {
        sqlite3_stmt *statement = nil;
        const char *selectSQL = [sqlString UTF8String];
        if (sqlite3_prepare_v2(database, selectSQL, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                int fieldCount = sqlite3_data_count(statement);
                for (int i=0; i<fieldCount; i++) {
                    NSString *fieldName = [NSString stringWithFormat:@"%s", sqlite3_column_name(statement, i)];
                    NSString *fieldValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                    [dataArray setObject:fieldValue forKey:fieldName];
                }
            }
        }
        sqlite3_finalize(statement);
    }
    [self close];
    return [NSDictionary dictionaryWithDictionary:dataArray];
}

- (BOOL)deleteDB{
    NSArray *dbFolderPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbFilePath = [[dbFolderPath objectAtIndex:0] stringByAppendingPathComponent:dbName];
    NSFileManager *fileMana = [NSFileManager defaultManager];
    return [fileMana removeItemAtPath:dbFilePath error:nil];
}

- (NSString*)replacSQLString:(NSString *)sqlString
{
    [sqlString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    [sqlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    [sqlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    [sqlString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return sqlString;
}
@end
