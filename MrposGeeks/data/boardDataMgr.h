//
//  boardDataMgr.h
//  MrposGeeks
//
//  Created by Admin on 2016/12/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#ifndef boardDataMgr_h
#define boardDataMgr_h

@interface boardDataMgr : NSObject {
    NSMutableArray* areaAry;
}

@property (nonatomic, retain) NSMutableArray *areaAry;

+ (id)instance;
@end

@interface areaData : NSObject {
    NSString* areaId;
    NSString* areaName;
    NSString* areaNotice;
    bool enable;
    NSMutableArray* tableAry;
}
@property (nonatomic, retain) NSString* areaId;
@property (nonatomic, retain) NSString* areaName;
@property (nonatomic, retain) NSString* areaNotice;
@property bool enable;
@property (nonatomic, retain) NSMutableArray *tableAry;

@end

@interface tableData : NSObject {
    NSString* areaId;
    NSString* tabldId;
    NSString* tableName;
    bool enable;
    int capacity;
}
@property (nonatomic, retain) NSString* areaId;
@property (nonatomic, retain) NSString* tabldId;
@property (nonatomic, retain) NSString* tableName;
@property bool enable;
@property int capacity;
@end

#endif /* boardDataMgr_h */
